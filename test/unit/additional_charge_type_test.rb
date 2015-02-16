require 'test_helper'

class AdditionalChargeTypeTest < ActiveSupport::TestCase

  context 'associations' do
    should have_many(:additional_charges)
    should belong_to(:instance)
  end

  context 'validations' do
    should validate_presence_of(:name)
    should validate_presence_of(:status)
    should validate_presence_of(:amount)
    should validate_presence_of(:currency)
    should validate_presence_of(:commission_for)
    should_not allow_value('wrong').for(:status)
    should allow_value('mandatory').for(:status)
    should_not allow_value('wrong').for(:commission_for)
    should allow_value('mpo').for(:commission_for)
  end

  should 'have a valid factory' do
    act = FactoryGirl.build(:additional_charge_type)
    assert act.valid?, true
  end

end
