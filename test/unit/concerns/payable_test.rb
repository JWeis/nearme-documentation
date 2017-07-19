require 'test_helper'

class PayableTest < ActiveSupport::TestCase
  context 'monetization' do
    should 'be included in Reservation' do
      transactable = FactoryGirl.create(:transactable)
      FactoryGirl.create(:additional_charge_type)
      FactoryGirl.create(:for_host_additional_charge_type)
      FactoryGirl.create(:transactable_additional_charge_type,
                         additional_charge_type_target: [transactable.id, 'Transactable'].join(','))

      reservation = FactoryGirl.build(:inactive_reservation, transactable: transactable)
      reservation.save

      assert_equal Money.new(50_00), reservation.subtotal_amount
      assert_equal Money.new(5_00), reservation.service_fee_amount_guest
      assert_equal Money.new(5_00), reservation.service_fee_amount_host
      assert_equal Money.new(10_00), reservation.service_additional_charges
      assert_equal Money.new(20_00), reservation.host_additional_charges

      # Total to pay 50 + 5 + 30 = 85
      assert_equal Money.new('85_00'), reservation.total_amount

      # assert_equal 500, reservation.payment.final_service_fee_amount_host_cents
      # assert_equal 8500, reservation.payment.total_amount_cents
    end
  end
end