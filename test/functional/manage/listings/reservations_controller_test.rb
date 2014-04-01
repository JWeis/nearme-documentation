require 'test_helper'

class Manage::Listings::ReservationsControllerTest < ActionController::TestCase

  setup do
    @reservation = FactoryGirl.create(:reservation_with_credit_card)
    @user = @reservation.listing.creator
    sign_in @user
    stub_mixpanel
    stub_request(:post, "https://www.googleapis.com/urlshortener/v1/url")
    Billing::Gateway::Incoming.any_instance.stubs(:charge)
  end

  should "track and redirect a host to the Manage Guests page when they confirm a booking" do
    ReservationMailer.expects(:notify_guest_of_confirmation).returns(stub(deliver: true)).once
    ReservationMailer.expects(:notify_host_of_confirmation).returns(stub(deliver: true)).once
    ReservationSmsNotifier.expects(:notify_guest_with_state_change).returns(stub(deliver: true)).once

    @tracker.expects(:confirmed_a_booking).with do |reservation|
      reservation == assigns(:reservation)
    end
    @tracker.expects(:updated_profile_information).with do |user|
      user == assigns(:reservation).owner
    end
    @tracker.expects(:updated_profile_information).with do |user|
      user == assigns(:reservation).host
    end
    post :confirm, { listing_id: @reservation.listing.id, id: @reservation.id }
    assert_redirected_to manage_guests_dashboard_path
  end

  should "track and redirect a host to the Manage Guests page when they reject a booking" do
    ReservationMailer.expects(:notify_guest_of_rejection).returns(stub(deliver: true)).once
    ReservationSmsNotifier.expects(:notify_guest_with_state_change).returns(stub(deliver: true)).once

    @tracker.expects(:rejected_a_booking).with do |reservation|
      reservation == assigns(:reservation)
    end
    @tracker.expects(:updated_profile_information).with do |user|
      user == assigns(:reservation).owner
    end
    @tracker.expects(:updated_profile_information).with do |user|
      user == assigns(:reservation).host
    end
    put :reject, { listing_id: @reservation.listing.id, id: @reservation.id }
    assert_redirected_to manage_guests_dashboard_path
  end

  should "track and redirect a host to the Manage Guests page when they cancel a booking" do
    ReservationMailer.expects(:notify_guest_of_cancellation_by_host).returns(stub(deliver: true)).once
    ReservationSmsNotifier.expects(:notify_guest_with_state_change).returns(stub(deliver: true)).once

    @reservation.confirm # Must be confirmed before can be cancelled
    @tracker.expects(:cancelled_a_booking).with do |reservation, custom_options|
      reservation == assigns(:reservation) && custom_options == { actor: 'host' }
    end
    @tracker.expects(:updated_profile_information).with do |user|
      user == assigns(:reservation).owner
    end
    @tracker.expects(:updated_profile_information).with do |user|
      user == assigns(:reservation).host
    end
    post :host_cancel, { listing_id: @reservation.listing.id, id: @reservation.id }
    assert_redirected_to manage_guests_dashboard_path
  end

  should "refund booking on cancel" do
    @reservation = FactoryGirl.create(:charge).reference.reservation
    @reservation.stubs(:attempt_payment_capture).returns(true)
    @reservation.confirm!
    @reservation.update_column(:payment_status, Reservation::PAYMENT_STATUSES[:paid])
    sign_in @reservation.listing.creator
    User.any_instance.stubs(:accepts_sms_with_type?)
    YAML.expects(:load).returns(stub(:id => 'abc'))
    Stripe::Charge.expects(:retrieve).returns(stub(:refund => stub(:to_yaml => {})))
    assert_difference 'Refund.count' do
      post :host_cancel, { listing_id: @reservation.listing.id, id: @reservation.id }
    end
    assert_redirected_to manage_guests_dashboard_path
    assert_equal 'refunded', @reservation.reload.payment_status
  end

  context 'PUT #reject' do
    should 'set rejection reason' do
      ReservationMailer.expects(:notify_guest_of_rejection).returns(stub(deliver: true)).once
      ReservationIssueLogger.expects(:rejected_with_reason).with(@reservation, @user)
      ReservationSmsNotifier.expects(:notify_guest_with_state_change).returns(stub(deliver: true)).once
      put :reject, { listing_id: @reservation.listing.id, id: @reservation.id, reservation: { rejection_reason: 'Dont like him' } }
      assert_equal @reservation.reload.rejection_reason, 'Dont like him'
    end
  end

  context 'versions' do

    should 'store new version after confirm' do
      # 2 because attempt charge is triggered, which if successful generates second version
      assert_difference('Version.where("item_type = ? AND event = ?", "Reservation", "update").count', 2) do
        with_versioning do
          post :confirm, { listing_id: @reservation.listing.id, id: @reservation.id }
        end
      end
    end

    should 'store new version after reject' do
      assert_difference('Version.where("item_type = ? AND event = ?", "Reservation", "update").count') do
        with_versioning do
          put :reject, { listing_id: @reservation.listing.id, id: @reservation.id, reservation: { rejection_reason: 'Dont like him' } }
        end
      end
    end

    should 'store new version after cancel' do
      @reservation.confirm
      assert_difference('Version.where("item_type = ? AND event = ?", "Reservation", "update").count') do
        with_versioning do
          post :host_cancel, { listing_id: @reservation.listing.id, id: @reservation.id }
        end
      end
    end   

  end

end

