require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  should belong_to(:company)
  should have_many(:listings)

  should validate_presence_of(:company_id)
  should validate_presence_of(:name)
  should validate_presence_of(:description)
  should validate_presence_of(:address)
  should validate_presence_of(:latitude)
  should validate_presence_of(:longitude)
  should_not allow_value('not_an_email').for(:email)
  should allow_value('an_email@domain.com').for(:email)

  should_not allow_value('xxx').for(:currency)
  should allow_value('USD').for(:currency)

  should allow_value('x' * 250).for(:description)
  should_not allow_value('x' * 251).for(:description)

  context "required_organizations" do
    context "when require_organiation_membership is true" do
      context "and the location has organizations" do
        should "be the organizations" do
          location = Location.new
          location.organizations << Organization.new
          location.require_organization_membership = true
          assert location.required_organizations == location.organizations
        end
      end
    end

    context "when require_organization_membership is false" do
      should "be empty" do
        location = Location.new
        location.organizations << Organization.new
        assert location.required_organizations.none?
      end
    end
  end

  context "#description" do
    context "when not set" do
      context "and there is not a listing for the location" do
        should "return an empty string" do
          location = Location.new
          assert_equal "", location.description
        end
      end
      context "and there is a listing with a description" do
        should "return the first listings description" do
          location = Location.new
          listing = Listing.new(description: "listing description")
          location.listings << listing
          assert_equal "listing description", location.description
        end
      end
    end
  end
  context "availability" do
    should "return an Availability::Summary for the Location's availability rules" do
      location = Location.new
      location.availability_rules << AvailabilityRule.new(:day => 0, :open_hour => 6, :open_minute => 0, :close_hour => 20, :close_minute => 0)

      assert location.availability.is_a?(AvailabilityRule::Summary)
      assert location.availability.open_on?(:day => 0, :hour => 6)
      assert !location.availability.open_on?(:day => 1)
    end
  end

  context "creating address components" do

    setup do
      @location = FactoryGirl.create(:ursynowska_address_components)
    end

    context 'creates address components for new record' do

      should " create address components" do
        assert_equal(5, @location.address_components.count)
      end

      should "be able to get city" do
        assert_equal('Warsaw', @location.address_components["city"])
        assert_equal('Mokotow', @location.address_components["suburb"])
      end

    end

    context 'formatted address has not changed' do


      should "not modify address components" do
        previous_address_components = @location.address_components
        @location.phone = "000 0000 000"
        @location.address_components_hash = FactoryGirl.attributes_for(:san_francisco_address_components)[:address_components_hash]
        @location.save!
        @location.reload
        assert_equal(previous_address_components, @location.address_components)
      end

    end

    context 'formatted address has changed' do

      should "modify address components" do
        new_attributes = FactoryGirl.attributes_for(:san_francisco_address_components)
        @location.formatted_address = new_attributes[:formatted_address]
        @location.address_components_hash = new_attributes[:address_components_hash]
        @location.save!
        @location.reload
        assert_equal("San Francisco", @location.address_components["city"])
      end

    end

  end


end
