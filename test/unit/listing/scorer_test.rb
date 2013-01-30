require 'test_helper'

class Listing::ScorerTest < ActiveSupport::TestCase

  context "with a set of test listings" do

    setup do
      @listings = [ FactoryGirl.create(:listing_in_auckland), FactoryGirl.create(:listing_in_san_francisco),
                    FactoryGirl.create(:listing_in_cleveland) ]

      @scorer   = Listing::Scorer.new(@listings)
    end

    context "with some listings that have amenities, prices and organisations" do
      setup do
        @wifi          = FactoryGirl.create(:amenity, name: "Wi-Fi")
        @drinks_fridge = FactoryGirl.create(:amenity, name: "Drinks Fridge")

        @listings.first.price_cents = 234.50 * 100
        @listings[1].price_cents    = 900.00 * 100
        @listings.last.price_cents  = 123.90 * 100

        @search_attrs = {
          boundingbox:   { start: { lat: -41.293507, lon: 174.776279 }, end: { lat: -42, lon: 175 } },
          amenities:     [ @wifi.id, @drinks_fridge.id ],
          price:         { min: 100, max: 900 }
        }
        @search_params = Listing::Search::Params::Api.new(@search_attrs)
      end

      context "overall scoring" do
        should "correctly score and weight all components " do
          Listing::Scorer.score(@listings, @search_params)

          assert_equal 33.33, @listings.first.score
          assert_equal 65.0,  @listings.last.score
          assert_equal 41.67, @listings[1].score
        end
      end

      context "with strict matches" do
        should "return strict_match as true for listings which fall exactly within the criteria" do
          @listings.first.location.amenities     = [ @wifi, @drinks_fridge ]
          params = Listing::Search::Params::Api.new(@search_attrs.merge(price: { min: 100, max: 250 }))

          Listing::Scorer.score(@listings, params)

          assert_equal [true, false, false], @listings.map(&:strict_match)
        end
      end
    end

    context "scoring based on distance from search area center" do
      should "score correctly" do
        search_area = Listing::Search::Area.new(Coordinate.new(-41.293507, 174.776279), 5.0)
        @scorer.score_search_area search_area

        assert_equal 33.33, @scorer.scores[@listings.first][:search_area]
        assert_equal 100.0, @scorer.scores[@listings.last][:search_area]
      end
    end

    context "scoring based upon geospatial search" do
      should "return matched listings with scores based on parameters" do
        @listings.each_with_index do |l, i|
          l.sphinx_attributes = { "@geodist" => i * 1_000 }
        end
        @scorer.score_search_area stub()

        assert_equal 33.33, @scorer.scores[@listings.first][:search_area]
        assert_equal 100.0, @scorer.scores[@listings.last][:search_area]
      end
    end

    context "scoring based on number of matched amenities" do
      setup do
        @wifi          = FactoryGirl.create(:amenity, name: "Wi-Fi")
        @drinks_fridge = FactoryGirl.create(:amenity, name: "Drinks Fridge")
        @pool_table    = FactoryGirl.create(:amenity, name: "Pool Table")

        @listings.first.location.amenities = [@wifi, @drinks_fridge, @pool_table]
        @listings.last.location.amenities  = [@wifi, @drinks_fridge, @pool_table]
      end

      should "score correctly" do
        @scorer.send(:score_amenities, [@wifi.id, @pool_table.id])

        # all amenities
        assert_equal 33.33, @scorer.scores[@listings.first][:amenities]
        assert_equal 33.33, @scorer.scores[@listings.last][:amenities]

        # no amenities
        assert_equal 66.67, @scorer.scores[@listings[1]][:amenities]

        # now try again with only some of the amenities (wifi is down!)
        @listings.last.location.amenities  = [@drinks_fridge, @pool_table]
        @scorer.send(:score_amenities, [@wifi.id, @pool_table.id])

        assert_equal 33.33, @scorer.scores[@listings.first][:amenities]
        assert_equal 66.67, @scorer.scores[@listings.last][:amenities]
      end

      should "return a strict_match if all requested amenities are available" do
        @scorer.score_amenities [@wifi.id, @drinks_fridge.id]

        assert @scorer.strict_matches[@listings.first][:amenities]
        assert !@scorer.strict_matches[@listings[1]][:amenities]
        assert @scorer.strict_matches[@listings.last][:amenities]
      end
    end

    context "scoring based on price" do
      setup do
        @listings.first.price_cents = 234.50 * 100
        @listings[1].price_cents = 900.00 * 100
        @listings.last.price_cents =  123.90 * 100
      end

      should "score correctly" do
        @scorer.score_price PriceRange.new(150, 300)

        assert_equal 33.33, @scorer.scores[@listings.first][:price]
        assert_equal 66.67, @scorer.scores[@listings.last][:price]
        assert_equal 100.0, @scorer.scores[@listings[1]][:price]
      end

      # i.e $50 more expensive than requested is the same as $50 cheaper
      should "score listings based on absolute difference from the price range" do
        @listings.first.price_cents = 150 * 100
        @listings.last.price_cents  = 50 * 100

        @scorer.score_price PriceRange.new(100, 100)

        assert_equal 33.33, @scorer.scores[@listings.first][:price]
        assert_equal 33.33, @scorer.scores[@listings.last][:price]
      end

      should "return a strict match if the listing price is between the minimum and maximum range" do
        @scorer.score_price PriceRange.new(150, 250)

        assert @scorer.strict_matches[@listings.first][:price]
        assert !@scorer.strict_matches[@listings[1]][:price]
        assert !@scorer.strict_matches[@listings.last][:price]
      end

    end

    context "scoring based on availability" do
      setup do
        @start_date = 7.days.from_now.beginning_of_week.to_date
        @end_date   = @start_date + 5

        @listings.each { |l| l.update_attribute(:quantity, 2) }

        create_reservation_for(@start_date, @end_date, @listings.first)

        assert_equal 1, @listings.first.availability_for(@start_date)
        assert_equal 2, @listings.last.availability_for(@start_date)
      end

      should "score correctly" do
        @scorer.score_availability Listing::Search::Params::Availability.new(dates: { start: @start_date, end: @end_date }, quantity: { min: 1 })

        assert_equal 33.33, @scorer.scores[@listings.first][:availability]
        assert_equal 33.33, @scorer.scores[@listings.last][:availability]
      end

      should "return a strict match if enough desks are available for each day in the range" do
        2.times { create_reservation_for(@start_date, @end_date, @listings[1]) }
        assert_equal 0, @listings[1].availability_for(@start_date)

        @scorer.score_availability Listing::Search::Params::Availability.new(dates: { start: @start_date, end: @end_date }, quantity: { min: 2 })

        assert !@scorer.strict_matches[@listings.first][:availability] # only 1 desk available
        assert !@scorer.strict_matches[@listings[1]][:availability]    # no desks available
        assert @scorer.strict_matches[@listings.last][:availability]   # 2 desks available
      end
    end

  end

  private

    def create_reservation_for(start_date, end_date, listing)
      periods = (start_date...end_date).map do |d|
        ReservationPeriod.new(date: d, listing_id: listing.id, quantity: 1)
      end

      r = listing.reservations.build(:user => FactoryGirl.create(:user))
      (start_date...end_date).map do |d|
        r.add_period(d, 1)
      end
      r.save!
    end

end
