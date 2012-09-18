class Listing
  module Search
    DEFAULT_MIDPOINT_SEARCH_RADIUS = 15_000

    class SearchTypeNotSupported < StandardError; end

    extend ActiveSupport::Concern

    included do
      # score is to be used by searches. It isn't persisted.
      # Ignore it for the most part.
      attr_accessor :score

      # strict_match is used to indicate search results that match all relevant criteria
      attr_accessor :strict_match

      # thinking sphinx index
      define_index do
        join location
        join location.organizations
        where  "locations.id is not null"

        indexes :name, :description

        has "radians(#{Location.table_name}.latitude)",  as: :latitude,  type: :float
        has "radians(#{Location.table_name}.longitude)", as: :longitude, type: :float

        # an organization id of 0 in the sphinx index means the entry does not require organization membership
        # (i.e the listing is public)
        has "CASE locations.require_organization_membership
          WHEN TRUE THEN array_to_string(array_agg(\"organizations\".\"id\"), ',')
          ELSE '0'
        END", as: :organization_ids, type: :multi

        group_by :latitude, :longitude, :require_organization_membership
      end

      sphinx_scope(:visible_for) do |user|
        orgs = (user) ? user.organization_ids : []
        # 0 indicactes a listing with no organization membership required - see define_index block
        orgs << 0

        { with: { organization_ids: orgs } }
      end

    end

    module ClassMethods

      def find_by_search_params(params)
        params.symbolize_keys!

        # make sure that private listings aren't shown unless the user is authenticated
        # this uses a sphinx scope
        scope = Listing.where("location_id is not null").visible_for(params.delete(:current_user))


        scope = if params.has_key?(:boundingbox)
          find_by_boundingbox(scope, params[:boundingbox])
        elsif params.has_key?(:midpoint)
          find_by_midpoint(scope, params[:midpoint], params[:radius].presence.try(:to_i) || DEFAULT_MIDPOINT_SEARCH_RADIUS)
        elsif params.has_key?(:query)
          find_by_keyword(scope, params.delete(:query))
        else
          raise SearchTypeNotSupported.new("You must specify either a bounding box or keywords to search by")
        end

        # convert to array rather than ThinkingSphinx::Search
        listings = scope.to_a

        # now score listings
        Scorer.score(listings, params)

        # return scored listings
        listings.sort{|a,b| b.score <=> a.score }
      end

      # TODO: Roll this into Sphinx search (used by web frontend)
      def search_by_location(search)
        return self if search[:lat].nil? || search[:lng].nil?

        distance = if (search[:southwest] && search[:southwest][:lat] && search[:southwest][:lng]) &&
                      (search[:northeast] && search[:northeast][:lat] && search[:northeast][:lng])
          Geocoder::Calculations.distance_between([ search[:southwest][:lat].to_f, search[:southwest][:lng].to_f ],
                                                  [ search[:northeast][:lat].to_f, search[:northeast][:lng].to_f ], units: :km)
        else
          30
        end
        Location.near([ search[:lat].to_f, search[:lng].to_f ], distance, order: "distance", units: :km)
      end

      private

        def find_by_midpoint(scope, midpoint, radius_m = DEFAULT_MIDPOINT_SEARCH_RADIUS)
          # sphinx needs the coordinates in radians
          midpoint_radians = Geocoder::Calculations.to_radians(midpoint)

          scope.search(
            geo:  midpoint_radians,
            with: { "@geodist" => 0.0...radius_m.to_f }
          )
        end

        # we use Sphinx's geosearch here, which takes a midpoint and radius
        def find_by_boundingbox(scope, boundingbox)
          boundingbox.symbolize_keys!
          boundingbox = boundingbox.inject({}) { |r, h| k, v = h; r[k] = v.symbolize_keys!; r } # my kingdom for deep_symbolize_keys...

          north_west = [boundingbox[:start][:lat].to_f, boundingbox[:start][:lon].to_f]
          south_east = [boundingbox[:end][:lat].to_f,   boundingbox[:end][:lon].to_f]

          midpoint         = Geocoder::Calculations.geographic_center([north_west, south_east])
          radius_m         = Geocoder::Calculations.distance_between(north_west, midpoint) * 1_000

          find_by_midpoint(scope, midpoint, radius_m)
        end

        def find_by_keyword(scope, query)
          # sphinx :)
          scope.search(query)
        end

    end
  end
end
