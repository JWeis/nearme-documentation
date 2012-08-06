require 'test_helper'

class V1::ListingsControllerTest < ActionController::TestCase

  ##
  # Display

  test "show should display a listing" do
    get :show, id: 1
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

  test "should accept reservation" do
    authenticate!
    raw_post :reservation, { id: 1 }, valid_reservation_params.to_json
    assert_response :success
  end

  test "reservation should raise when a listing is not found" do
    authenticate!
    raw_post :reservation, {id: 999999999}, valid_reservation_params.to_json
    assert_response :unprocessable_entity
  end

  test "reservation should raise when json is missing" do
    assert_raise DNM::InvalidJSON do
      authenticate!
      raw_post :reservation, {id: 1}, ''
    end
  end

  test "reservation should raise when dates in json is missing" do
    assert_raise DNM::MissingJSONData do
      authenticate!
      params = valid_reservation_params
      params.delete "dates"
      raw_post :reservation, {id: 1}, params.to_json
    end
  end

  ##
  # Availability

  test "should get availability" do
    raw_post :availability, {id: 1}, '{ "dates": ["2012-01-01", "2012-01-02", "2012-01-03"] }'
    assert_response :success
  end

  test "availability should raise when json is missing" do
    assert_raise DNM::InvalidJSONData do
      raw_post :availability, {id: 1}, ''
    end
  end

  ##
  # Inquiry

  test "should accept inquiry" do
    authenticate!
    raw_post :inquiry, {id: 1}, '{ "message": "hello" }'
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
      raw_post :inquiry, {id: 1}, '{ "no_message": "I am missing!" }'
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
      raw_post :share, {id: 1}, '{ "message": "no email addresses" }'
    end
  end

  test "share should raise when name in json is missing" do
    assert_raise DNM::MissingJSONData do
      authenticate!
      raw_post :share, {id: 1}, '{ "to": [{ "email": "name-is-missing@example.com" }] }'
    end
  end

  test "share should raise when email in json is missing" do
    assert_raise DNM::MissingJSONData do
      authenticate!
      raw_post :share, {id: 1}, '{ "to": [{ "name": "Mr. No Having Email" }] }'
    end
  end

  ##
  # Patrons

  test "should show patrons for a listing" do
    get :patrons, id: 1
    assert_response :success
  end

  ##
  # Connections

  test "should show connections for a listing" do
    pending "until Sai reviews"
    get :connections, id: 1
    assert_response :success
  end

  private

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
      "dates" => ["2013-01-01", "2013-01-02"] }
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
