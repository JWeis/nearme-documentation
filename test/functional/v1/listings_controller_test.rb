require 'test_helper'
require 'helpers/gmaps_fake'

class V1::ListingsControllerTest < ActionController::TestCase


  setup do
    FactoryGirl.create(:transactable_type_listing)
    @listing = FactoryGirl.create(:transactable)
  end

  ##
  # C*UD
  #
  test "create should be successful" do
    location = get_authenticated_location
    post :create, {
      listing: {
        photos_attributes: [FactoryGirl.attributes_for(:photo)],
        location_id: location.id,
        name: 'My listing',
        description: 'nice listing',
        listing_type: "Desk",
        hourly_reservations: true,
        hourly_price_cents: 1000,
        quantity: 10
      },
      format: 'json'
    }
    assert_response :success
  end

  test "update should be successful" do
    listing = get_authenticated_listing
    new_name = 'My listing'
    put :update, id: listing, listing: { name: new_name, daily_price: "10-50" }, format: 'json'
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

  test "should search" do
    raw_post :search, {}, valid_search_params.to_json
    assert_response :success
  end

  test "search should raise when boundingbox is missing" do
    assert_raise DNM::MissingJSONData do
      raw_post :search, {}, valid_additional_params.to_json
    end
  end

  ##
  # Query

  test "should query" do
    WebMock.disable_net_connect!
    GmapsFake.stub_requests
    raw_post :query, {}, valid_query_params.to_json
    assert_response :success
  end

  test "query should raise when boundingbox is missing" do
    assert_raise DNM::MissingJSONData do
      raw_post :query, {}, valid_additional_params.to_json
    end
  end

  ##
  # Reservation

  context "when successful" do
    setup do
      stub_mixpanel
      authenticate!
      ReservationMailer.expects(:notify_host_with_confirmation).returns(stub(deliver: true)).once
      ReservationMailer.expects(:notify_guest_with_confirmation).returns(stub(deliver: true)).once

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
      raw_post :reservation, {id: @listing.id}, ''
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
    stub_mixpanel
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
      "date" => {
        "start" => "2012-06-01",
        "end" =>   "2012-06-15"
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
end
