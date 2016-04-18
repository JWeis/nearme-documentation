require 'test_helper'
require 'helpers/gmaps_fake'

class V1::ListingsControllerTest < ActionController::TestCase


  setup do
    FactoryGirl.create(:transactable_type_listing)
    @listing = FactoryGirl.create(:transactable)
    FactoryGirl.create(:manual_payment_gateway)
  end

  ##
  # C*UD
  #
  test "create should be successfulxxx" do
    location = get_authenticated_location
    post :create, {
      listing: {
        photos_attributes: [FactoryGirl.attributes_for(:photo)],
        location_id: location.id,
        name: 'My listing',
        description: 'nice listing',
        listing_type: "Desk",
        quantity: 10,
      }.merge(action_type_attibutes(nil, 10, 1, 'hour')),
      format: 'json'
    }
    assert_response :success
  end

  test "update should be successful" do
    listing = get_authenticated_listing
    new_name = 'My listing'
    put :update, id: listing, listing: { name: new_name }, format: 'json'
    listing = Transactable.find(listing.id)
    assert_equal new_name, listing.name
    assert_response :success
  end

  test "destroy should be successful" do
    @listing = get_authenticated_listing
    delete :destroy, id: @listing.id, format: 'json'
    assert_response :success
  end

  ##
  # Display

  test "show should display a listing" do
    get :show, id: @listing.id
    assert_response :success
  end

  test "show should raise when a listing is not found" do
    get :show, id: 999999999
    assert_response :unprocessable_entity
  end

  ##
  # Search

  test "search should raise when boundingbox is missing" do
    assert_raise DNM::MissingJSONData do
      raw_post :search, {}, valid_additional_params.to_json
    end
  end

  ##
  # Query
  context 'search' do
    setup do
      Rails.application.config.use_elastic_search = true
      Transactable.__elasticsearch__.index_name = 'transactables_test'
      Transactable.__elasticsearch__.create_index!(force: true)
      Transactable.searchable.import
      Transactable.__elasticsearch__.refresh_index!
    end

    teardown do
      Transactable.__elasticsearch__.client.indices.delete index: Transactable.index_name
      Rails.application.config.use_elastic_search = false
    end

    should "should search" do
      raw_post :search, {}, valid_search_params.to_json
      assert_response :success
    end

    should "should query" do
      WebMock.disable_net_connect!(allow: %r{localhost:9200})
      GmapsFake.stub_requests
      raw_post :query, {}, valid_query_params.to_json
      assert_response :success
    end
  end

  ##
  # Reservation

  context "when successful" do
    setup do
      authenticate!

      WorkflowStepJob.expects(:perform).with do |klass, int|
        klass == WorkflowStep::ReservationWorkflow::CreatedWithoutAutoConfirmation
      end

      raw_post :reservation, { id: @listing.id }, valid_reservation_params.to_json
      @reservation = Transactable.find_by_id(@listing.id).reservations.first
    end

    should "respond with success" do
      assert_response :success
    end

    should "set quantity" do
      assert_equal 1, @reservation.quantity
    end

    should "create periods" do
      periods = @reservation.periods
      reserved_dates = periods.map(&:date)

      assert reserved_dates.include? Date.parse(30.days.from_now.monday.strftime("%Y-%m-%d"))
      assert reserved_dates.include? Date.parse((30.days.from_now.monday+1.day).strftime("%Y-%m-%d"))
    end
  end

  test "reservation should raise when a listing is not found" do
    authenticate!
    raw_post :reservation, {id: 999999999}, valid_reservation_params.to_json
    assert_response :unprocessable_entity
  end

  test "reservation should raise when json is missing" do
    assert_raise DNM::InvalidJSON do
      authenticate!
      raw_post :reservation, {id: @listing.id}, ''.to_json
    end
  end

  test "reservation should raise when dates in json is missing" do
    assert_raise DNM::MissingJSONData do
      authenticate!
      params = valid_reservation_params
      params.delete "dates"
      raw_post :reservation, {id: @listing.id}, params.to_json
    end
  end

  ##
  # Availability

  test "should get availability" do
    raw_post :availability, {id: @listing.id}, '{ "dates": ["2012-01-01", "2012-01-02", "2012-01-03"] }'
    assert_response :success
  end

  test "availability should raise when json is missing" do
    assert_raise DNM::InvalidJSONData do
      raw_post :availability, {id: @listing.id}, ''
    end
  end

  ##
  # Inquiry

  test "should accept inquiry" do
    authenticate!
    listing         = Transactable.find(@listing.id)
    listing.creator = FactoryGirl.create(:user)
    listing.save

    assert_difference "listing.inquiries.count", 1 do
      raw_post :inquiry, {id: @listing.id}, '{ "message": "hello" }'
    end
    assert_response :no_content
  end

  test "inquiry should raise when a listing is not found" do
    authenticate!
    raw_post :inquiry, {id: 999999999}, '{ "message": "hello" }'
    assert_response :unprocessable_entity
  end

  test "inquiry should raise when json is missing" do
    assert_raise DNM::MissingJSONData do
      authenticate!
      assert_no_difference "Transactable.find(@listing.id).inquiries.count" do
        assert_no_difference "ActionMailer::Base.deliveries.count" do
          raw_post :inquiry, {id: @listing.id}, '{ "no_message": "I am missing!" }'
        end
      end
    end
  end

  ##
  # Share

  test "share should raise when a listing is not found" do
    authenticate!
    raw_post :share, {id: 999999999}, '{ "to": [{ "name": "John Carter", "email": "john@example.com" }] }'
    assert_response :unprocessable_entity
  end

  test "share should raise when json is missing" do
    assert_raise DNM::MissingJSONData do
      authenticate!
      raw_post :share, {id: @listing.id}, '{ "message": "no email addresses" }'
    end
  end

  test "share should raise when name in json is missing" do
    assert_raise DNM::MissingJSONData do
      authenticate!
      raw_post :share, {id: @listing.id}, '{ "to": [{ "email": "name-is-missing@example.com" }] }'
    end
  end

  test "share should raise when email in json is missing" do
    assert_raise DNM::MissingJSONData do
      authenticate!
      raw_post :share, {id: @listing.id}, '{ "to": [{ "name": "Mr. No Having Email" }] }'
    end
  end

  ##
  # Patrons

  test "should show patrons for a listing" do
    authenticate!
    get :patrons, id: @listing.id
    assert_response :success
  end

  ##
  # Connections

  test "should show connections for a listing" do
    authenticate!
    get :connections, id: @listing.id
    assert_response :success
  end

  private

  def get_authenticated_location
    authenticate!
    company = FactoryGirl.create(:company, :name => 'company_XYZ', :creator_id => @user.id)
    FactoryGirl.create(:location, :company_id => company.id)
  end

  def get_authenticated_listing
    location = get_authenticated_location
    FactoryGirl.create(:transactable, :location_id => location.id, :photos_count => 1)
  end

  def valid_search_params
    {
      "boundingbox" => {
        "start" => {
          "lat" => 37.0,
          "lon" => 128.0
        },
        "end" => {
          "lat" => 38.0,
          "lon" => 129.0
        }
      }
    }.merge valid_additional_params
  end

  def valid_query_params
    {
      "query" => "Desks Near Me"
    }.merge valid_additional_params
  end

  def valid_reservation_params
    { "quantity" => 1,
      "email" => "foo@example.com",
      "assignees" => [{ "name" => "John Carter", "email" => "john@example.com" }],
      "dates" => [30.days.from_now.monday.strftime("%Y-%m-%d"), (30.days.from_now.monday+1.day).strftime("%Y-%m-%d")] }
  end

  def valid_additional_params
    {
      "location" => {
        "lat" => 37.0,
        "lon" => 128.0
      },
      "availability" => {
        "dates" => {
          "start" => "2012-06-01",
          "end" =>   "2012-06-15"
        }
      },
      "quantity" => {
        "min" => 5,
        "max" => 12
      },
      "price" => {
        "min" => 25.00,
        "max" => 100.00
      },
      "amenities" => [ "wifi", "projector", "view" ],
    }
  end

  def action_type_attibutes(action_type, price, number_of_units, unit)
    pricing = action_type && action_type.pricings.by_number_and_unit(number_of_units, unit).first
    {
      action_types_attributes: [{
        transactable_type_action_type_id: TransactableType.first.action_types.first.id,
        enabled: 'true',
        type: action_type.try(:type) || 'Transactable::TimeBasedBooking',
        id: action_type.try(:id),
        pricings_attributes: [{
          transactable_type_pricing_id: TransactableType.first.time_based_booking.pricing_for([number_of_units, unit].join('_')).try(:id),
          enabled: '1',
          id: pricing.try(:id),
          price: price,
          number_of_units: number_of_units,
          unit: unit
        }]
      }]
    }
  end
end
