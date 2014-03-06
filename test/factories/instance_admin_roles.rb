# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :instance_admin_role do

    sequence(:name) { |n| "InstanceAdminRole #{n}" }
    instance_id { (Instance.default_instance.presence || FactoryGirl.create(:instance)).id }
    permission_analytics true
    permission_settings false
    permission_theme false
    permission_manage false

    factory :instance_admin_role_default do
      name 'Default'
      instance_id nil
      permission_analytics true
      permission_settings false
      permission_theme false
      permission_blog false
      permission_manage false
    end

    factory :instance_admin_role_administrator do
      name 'Administrator'
      instance_id nil
      permission_analytics true
      permission_settings true
      permission_theme true
      permission_manage true
      permission_support true
    end

    factory :instance_admin_role_blog do
      name 'Blog'
      instance_id nil
      permission_analytics true
      permission_settings false
      permission_theme false
      permission_manage false
      permission_blog true
    end
  end
end
