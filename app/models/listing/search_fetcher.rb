class Listing::SearchFetcher
  extend ::NewRelic::Agent::MethodTracer

  TOP_CITIES = ['san francisco', 'london', 'new york', 'los angeles', 'chicago']

  def initialize(filters = {})
    @midpoint = filters.fetch(:midpoint)
    @radius = filters.fetch(:radius)
    @filters = filters
  end

  def listings
    @listings = filtered_listings
  end

  def locations
    @locations = filtered_locations
  end

  private

  def filtered_locations
    @locations_scope = Location.includes(:listings)
    @locations_scope = @locations_scope.near(@midpoint, @radius, :order => "#{Address.order_by_distance_sql(@midpoint[0], @midpoint[1])} ASC") if @midpoint && @radius
    @locations_scope = @locations_scope.filtered_by_location_types_ids(@filters[:location_types_ids]) if @filters[:location_types_ids]
    @locations_scope = @locations_scope.filtered_by_industries_ids(@filters[:industries_ids]) if @filters[:industries_ids]
    @locations_scope = @locations_scope.merge(filtered_listings)
    @locations_scope
  end

  def filtered_listings
    @listings_scope = Transactable.searchable
    @listings_scope = @listings_scope.filtered_by_listing_types_ids(@filters[:listing_types_ids]) if @filters[:listing_types_ids]
    @listings_scope = @listings_scope.filtered_by_price_types(@filters[:listing_pricing] & Transactable::PRICE_TYPES.map(&:to_s)) if @filters[:listing_pricing]
    @listings_scope
  end

end
