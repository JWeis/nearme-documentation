require 'test_helper'

class LocationsControllerTest < ActionController::TestCase

include Devise::TestHelpers

  setup do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @company = FactoryGirl.create(:company_in_auckland, :creator_id => @user.id)
    @location = FactoryGirl.create(:location_in_auckland)
    @company.locations << @location
    stub_request(:get, /.*api\.mixpanel\.com.*/)
    @tracker = Analytics::EventTracker.any_instance
  end

  test "should return success status for show action if no listings" do
    get :show, :id => @location.id
    assert_response :success
  end

  should 'track location view' do
    @tracker.expects(:viewed_a_location).with do |location|
      location == assigns(:location)
    end
    get :show, id: @location.id
    assert_response :success
  end

end

