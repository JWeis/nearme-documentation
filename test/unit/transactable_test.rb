require 'test_helper'

class TransactableTest < ActiveSupport::TestCase

  context 'desksnearme instance' do
    subject { FactoryGirl.build(:transactable) }

    should belong_to(:location)
    should have_many(:reservations)

    should validate_presence_of(:location)
    should validate_presence_of(:name)
    should validate_presence_of(:listing_type)
    should validate_presence_of(:description)
    should validate_presence_of(:quantity)
    should allow_value(10).for(:quantity)
    should_not allow_value(-10).for(:quantity)

    should ensure_length_of(:description).is_at_most(250)
    should ensure_length_of(:name).is_at_most(50)
  end

  setup do
    @listing = FactoryGirl.build(:transactable)
  end

  context 'validation' do
    should 'not be valid if quantity is 0' do
      @listing.quantity = 0
      refute @listing.valid?
    end
  end

  context 'is trusted' do

    setup do
      @transactable = FactoryGirl.create(:transactable)
      @transactable.confidential_files = []
      @confidential_file = FactoryGirl.build(:confidential_file)
    end

    context 'instance does not require verification' do

      should 'be trusted even without confidential files' do
        assert @transactable.is_trusted?
      end

    end

    context 'instance does require verification' do

      setup do
        PlatformContext.current.instance.update_attribute(:onboarding_verification_required, true)
      end

      should 'not be trusted without confidential file' do
        refute @transactable.is_trusted?
      end

      should 'be trusted without confidential file if user is trusted' do
        User.any_instance.stubs(:is_trusted?).returns(true)
        assert @transactable.is_trusted?
      end

      should 'be trusted with confidential file that is accepted' do
        @confidential_file.review
        @confidential_file.accept
        @transactable.confidential_files << @confidential_file
        @transactable.save!
        assert @transactable.is_trusted?
      end

      context 'enabled' do
        setup do
          User.any_instance.stubs(:confidential_files).returns([@confidential_file])
        end

        should 'be enabled if is trusted' do
          Transactable.any_instance.stubs(:is_trusted?).returns(true)
          assert FactoryGirl.build(:transactable).enabled?
        end

        should 'not be enabled if is not trusted' do
          Transactable.any_instance.stubs(:is_trusted?).returns(false)
          refute FactoryGirl.build(:transactable).enabled?
        end

      end
    end
  end

  context "#photo_not_required" do
    should 'not require photo' do

      @listing.photo_not_required = true
      @listing.photos = []
      assert @listing.valid?
    end
  end

  context "#prices_by_days" do
    setup do
      @listing.save!
      @listing.daily_price = 100
      @listing.weekly_price=  400
      @listing.monthly_price = 1200

      # Force a 5 day block size
      @listing.stubs(:booking_days_per_week).returns(5)
    end

    should "be correct for all prices" do
      assert_equal({ 1 => 100, 5 => 400, 20 => 1200 }, @listing.prices_by_days)
    end

    should "be correct for day & week" do
      @listing.monthly_price = nil
      assert_equal({ 1 => 100, 5 => 400 }, @listing.prices_by_days)
    end

    should "be correct for day" do
      @listing.monthly_price = nil
      @listing.weekly_price = nil
      assert_equal({ 1 => 100 }, @listing.prices_by_days)
    end

    should "be correct for week & month" do
      @listing.daily_price = nil
      assert_equal({ 5 => 400, 20 => 1200 }, @listing.prices_by_days)
    end

    should "be correct for free" do
      @listing.daily_price = nil
      @listing.monthly_price = nil
      @listing.weekly_price = nil
      @listing.free = true
      assert_equal({ 1 => 0 }, @listing.prices_by_days)
    end

    should "be correct for different block size" do
      # Force a 3 day block size
      @listing.stubs(:booking_days_per_week).returns(3)
      assert_equal({ 1 => 100, 3 => 400, 12 => 1200 }, @listing.prices_by_days)
    end
  end

  context "free flag and prices" do

    should "valid if free flag is true and no prices are provided" do
      @listing.free = true
      @listing.daily_price = nil
      @listing.weekly_price = nil
      @listing.monthly_price = nil
      assert @listing.valid?
    end

    should "valid if free flag is false and at daily price is greater than zero" do
      @listing.free = false
      @listing.daily_price = 1
      @listing.weekly_price = nil
      @listing.monthly_price = nil
      assert @listing.valid?
    end

    should "valid if free flag is false and at weekly price is greater than zero" do
      @listing.free = false
      @listing.daily_price = 0
      @listing.weekly_price = 1
      @listing.monthly_price = nil
      assert @listing.valid?
    end

    should "valid if free flag is false and at monthly price is greater than zero" do
      @listing.free = false
      @listing.daily_price = 0
      @listing.weekly_price = 0
      @listing.monthly_price = 5
      assert @listing.valid?
    end

    should "be invalid if free flag is true and the hourly_reservations flag is true" do
      @listing.free = true
      @listing.hourly_reservations = true
      refute @listing.valid?
    end

    context 'instance observes min/max pricing constraints specified by instance admin' do

      should 'be valid if hourly price within specified range' do
        listing = FactoryGirl.create(:listing_from_transactable_type_with_price_constraints)
        listing.hourly_price_cents = 9999
        assert listing.valid?
        listing.hourly_price = 99
        assert listing.valid?
      end

      should 'be invalid if hourly price outside specified range' do
        listing = FactoryGirl.create(:listing_from_transactable_type_with_price_constraints)
        listing.hourly_price_cents = 100001
        refute listing.valid?
        listing.hourly_price = 100
        assert listing.valid?
      end

      should 'not be valid if hourly price is too low' do
        listing = FactoryGirl.create(:listing_from_transactable_type_with_price_constraints)
        listing.hourly_price_cents = 1
        refute listing.valid?
        listing.hourly_price = 11
        assert listing.valid?
      end

    end
  end

  context 'instance observes default min/max pricing constraints' do

    setup do
      @listing = FactoryGirl.build(:transactable)
    end

    should 'be valid if hourly price within range' do
      @listing.hourly_price = 1
      assert @listing.valid?
    end

    should 'be invalid if hourly price outside min range' do
      @listing.hourly_price = -1
      refute @listing.valid?
    end

    should 'be invalid if hourly price outside max range' do
      @listing.hourly_price = 2147483648
      refute @listing.valid?
    end
  end

  context "first available date" do

    teardown do
      Timecop.return
    end

    should "return monday for friday" do
      friday = Time.zone.today.sunday + 5.days
      Timecop.freeze(friday.beginning_of_day)
      assert_equal friday+3.day, @listing.first_available_date
    end

    should "return monday for saturday" do
      saturday = Time.zone.today.sunday + 6.days
      Timecop.freeze(saturday.beginning_of_day)
      assert_equal saturday+2.day, @listing.first_available_date
    end

    should "return monday for sunday" do
      sunday = Time.zone.today.sunday
      Timecop.freeze(sunday.beginning_of_day)
      assert_equal sunday+1.day, @listing.first_available_date
    end

    should "return tuesday for monday" do
      tuesday = Time.zone.today.sunday + 2
      Timecop.freeze(tuesday.beginning_of_day)
      assert_equal tuesday+1.day, @listing.first_available_date
    end

    should "return monday for tuesday if the whole week is booked" do
      ReservationMailer.expects(:notify_host_with_confirmation).returns(mailer_stub).once
      ReservationMailer.expects(:notify_guest_with_confirmation).returns(mailer_stub).once

      @listing.save!
      tuesday = Time.zone.today.sunday + 2
      Timecop.freeze(tuesday.beginning_of_day)
      dates = [tuesday]
      4.times do |i|
        dates << tuesday + i.day
      end
      @listing.reserve!(FactoryGirl.build(:user), dates, 1)
      # wednesday, thursday, friday = 3, saturday, sunday = 2 -> monday is sixth day
      assert_equal tuesday+6.day, @listing.first_available_date
    end

    should "return thursday for tuesday if there is one desk left" do
      ReservationMailer.expects(:notify_host_with_confirmation).returns(mailer_stub).twice
      ReservationMailer.expects(:notify_guest_with_confirmation).returns(mailer_stub).twice

      @listing.quantity = 2
      @listing.save!
      tuesday = Time.zone.today.sunday + 2
      Timecop.freeze(tuesday.beginning_of_day)
      # book all seats on wednesday
      @listing.reserve!(FactoryGirl.build(:user), [tuesday+1.day], 2)
      # leave one seat free on thursday
      @listing.reserve!(FactoryGirl.build(:user), [tuesday+2.day], 1)
      # the soonest day should be the one with at least one seat free
      assert_equal tuesday+2.day, @listing.first_available_date
    end

    should "return wednesday for monday if hourly reservation and custom availability template" do
      @listing.hourly_reservations = true
      @listing.hourly_price_cents = 5000
      @listing.availability_template_id = nil

      @listing.availability_rules.destroy_all
      @listing.save!

      @listing.availability_rules.create!({:day => 3, :open_hour => 9, :close_hour => 16, :open_minute => 0, :close_minute => 0})

      monday = Time.zone.today.sunday + 1
      Timecop.freeze(monday.beginning_of_day)

      assert_equal monday+2.day, @listing.first_available_date
    end
  end

  context 'metadata' do

    context 'populating photo hash' do
      setup do
        @listing = FactoryGirl.create(:transactable)
        @photo = @listing.photos.first
      end

      should 'initialize metadata' do
        @listing.expects(:update_metadata).with(:photos_metadata => [{
          :space_listing => @photo.image_url(:space_listing),
          :golden => @photo.image_url(:golden),
          :large => @photo.image_url(:large),
        }])
        @listing.populate_photos_metadata!
      end

      should 'trigger location metadata' do
        Location.any_instance.expects(:populate_photos_metadata!).once
        @listing.populate_photos_metadata!
      end

      context 'with second image' do

        setup do
          @photo2 = FactoryGirl.create(:photo, :listing => @listing)
        end

        should 'update existing metadata' do
          @listing.expects(:update_metadata).with(:photos_metadata => [
            {
              :space_listing => @photo.image_url(:space_listing),
              :golden => @photo.image_url(:golden),
              :large => @photo.image_url(:large),
            },
            {
              :space_listing => @photo2.image_url(:space_listing),
              :golden => @photo2.image_url(:golden),
              :large => @photo2.image_url(:large),
            }
          ])
          @listing.populate_photos_metadata!
        end
      end

    end

    context 'should_populate_creator_listings_metadata?' do

      setup do
        @listing = FactoryGirl.create(:transactable)
      end

      should 'return true if new listing is created' do
        assert @listing.creator.has_any_active_listings
      end

      should 'return true if listing is destroyed' do
        @listing.destroy
        refute @listing.creator.has_any_active_listings
      end

      should 'return true if draft changed' do
        @listing.update_attribute(:draft, Time.zone.now)
        assert @listing.should_populate_creator_listings_metadata?
      end

      should 'return false if name changed' do
        @listing.update_attribute(:name, 'new name')
        refute @listing.should_populate_creator_listings_metadata?
      end

      context 'triggering' do

        should 'not trigger populate listings metadata on user if condition fails' do
          User.any_instance.expects(:populate_listings_metadata!).never
          Transactable.any_instance.expects(:should_populate_creator_listings_metadata?).returns(false)
          FactoryGirl.create(:transactable)
        end

        should 'trigger populate listings metadata on user if condition succeeds' do
          User.any_instance.expects(:populate_listings_metadata!).once
          Transactable.any_instance.expects(:should_populate_creator_listings_metadata?).returns(true)
          FactoryGirl.create(:transactable)
        end

      end
    end

  end

  context 'foreign keys' do
    setup do
      @location = FactoryGirl.create(:location)
      @listing = FactoryGirl.create(:transactable, :location => @location)
    end

    should 'assign correct key immediately' do
      @listing = FactoryGirl.create(:transactable)
      assert @listing.creator_id.present?
      assert @listing.instance_id.present?
      assert @listing.company_id.present?
      assert @listing.listings_public
    end

    should 'assign correct creator_id' do
      assert_equal @location.creator_id, @listing.creator_id
    end

    should 'assign correct company_id' do
      assert_equal @location.company_id, @listing.company_id
    end

    should 'assign administrator_id' do
      @location.update_attribute(:administrator_id, @location.creator_id + 1)
      assert_equal @location.administrator_id, @listing.reload.administrator_id
    end

    context 'update company' do

      should 'assign correct creator_id' do
        @location.company.update_attribute(:creator_id, @location.company.creator_id + 1)
        assert_equal @location.company.creator_id, @listing.reload.creator_id
      end

      should 'assign correct company_id' do
        @location.update_attribute(:company_id, @location.company_id + 1)
        assert_equal @location.company_id, @listing.reload.company_id
      end

      should 'assign correct partner_id' do
        partner = FactoryGirl.create(:partner)
        @location.company.update_attribute(:partner_id, partner.id)
        assert_equal partner.id, @listing.reload.partner_id
      end

      should 'assign correct instance_id' do
        instance = FactoryGirl.create(:instance)
        @location.company.update_attribute(:instance_id, instance.id)
        PlatformContext.any_instance.stubs(:instance).returns(instance)
        assert_equal instance.id, @location.reload.instance_id
      end

      should 'update listings_public' do
        assert @listing.listings_public
        @listing.company.update_attribute(:listings_public, false)
        refute @listing.reload.listings_public
      end

    end
  end
end
