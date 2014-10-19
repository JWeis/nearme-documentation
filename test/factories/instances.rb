FactoryGirl.define do

  factory :instance do
    instance_type_id { (InstanceType.first || FactoryGirl.create(:instance_type)).id }
    sequence(:name) {|n| Instance.first ? "desks near me #{n}" : 'DesksNearMe'}
    bookable_noun 'Desk'
    lessor 'host'
    lessee 'guest'
    service_fee_guest_percent '10.00'
    service_fee_host_percent '10.00'

    facebook_consumer_key 'fb1'
    facebook_consumer_secret 'fb2'
    twitter_consumer_key 't1'
    twitter_consumer_secret 't2'
    linkedin_consumer_key 'li1'
    linkedin_consumer_secret 'li2'
    instagram_consumer_key 'i1'
    instagram_consumer_secret 'i2'

    after(:create) do |instance|
      instance.theme = FactoryGirl.create(:theme, :skip_compilation => true) unless instance.theme
    end

    factory :instance_with_price_constraints do
      min_hourly_price 10
      max_hourly_price 100
    end

    factory :instance_test_mode do
      test_mode true
      password_protected true
      marketplace_password "123456"
    end

    factory :instance_require_verification do
      after(:build) do |instance|
        approval_request_template = FactoryGirl.build(:approval_request_template, owner_type: 'User')
        instance.approval_request_templates = [approval_request_template]
      end
    end

  end

end
