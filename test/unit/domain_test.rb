require 'test_helper'

class DomainTest < ActiveSupport::TestCase

  should validate_uniqueness_of(:name)
  should validate_presence_of(:name)
  should validate_presence_of(:target_type)

  def setup
    @desks_near_me_domain = FactoryGirl.create(:domain, :name => 'desksnearme.com', :target => FactoryGirl.create(:instance))
    @company = FactoryGirl.create(:company)
    @example_domain = FactoryGirl.create(:domain, :name => 'example.com', :target => @company, :target_type => 'Company')
    @partner_domain = FactoryGirl.create(:domain, :name => 'partner.example.com', :target => FactoryGirl.create(:partner), :target_type => 'Partner')
  end

  context 'find_for_request' do

    setup do
      @request = mock()
    end

    should 'be able to find by host name' do
      @request.stubs(:host).returns('desksnearme.com')
      assert_equal @desks_near_me_domain, Domain.find_for_request(@request)
    end

    should 'be able to bypass www in host name' do
      @request.stubs(:host).returns('www.desksnearme.com')
      assert_equal @desks_near_me_domain, Domain.find_for_request(@request)
    end

  end

  context 'target' do
    should 'be able to detect that its target is instance' do
      assert @desks_near_me_domain.instance?
      assert !@desks_near_me_domain.white_label_company?
      assert !@example_domain.partner?

    end

    should 'be able to detect that its target is company' do
      assert @example_domain.white_label_company?
      assert !@example_domain.instance?
      assert !@example_domain.partner?
    end

    should 'be able to detect that its target is partner' do
      assert @partner_domain.partner?
      assert !@partner_domain.white_label_company?
      assert !@partner_domain.instance?
    end
  end

end

