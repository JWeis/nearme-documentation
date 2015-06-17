require 'test_helper'

class ReservationChargeTrackerJobTest < ActiveSupport::TestCase

  setup do
    stub_mixpanel
    PaymentGateway::StripePaymentGateway.any_instance.expects(:charge)
    @listing = FactoryGirl.create(:transactable, :daily_price => 89.39)
    @reservation = FactoryGirl.create(:reservation_with_credit_card, :listing => @listing)
    @reservation.create_billing_authorization(token: "token", payment_gateway: FactoryGirl.create(:stripe_payment_gateway), payment_gateway_mode: "test")
  end

  should 'perform tracking of confirmed reservation' do
    @reservation.confirm!
    Analytics::EventTracker.any_instance.expects(:track_charge).with(@reservation)
    ReservationChargeTrackerJob.perform(@reservation.id)
  end

  context 'cancelled' do
    setup do
      @reservation.confirm!
    end

    should 'do not perform tracking of cancelled reservation by host' do
      @reservation.host_cancel!
      Analytics::EventTracker.any_instance.expects(:track_charge).never
      ReservationChargeTrackerJob.perform(@reservation.id)
    end

    should 'do not perform tracking of cancelled reservation by user' do
      @reservation.user_cancel!
      Analytics::EventTracker.any_instance.expects(:track_charge).never
      ReservationChargeTrackerJob.perform(@reservation.id)
    end

  end
end
