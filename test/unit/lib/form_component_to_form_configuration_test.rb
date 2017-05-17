# frozen_string_literal: true
require 'test_helper'

class FormComponentToFormConfigurationTest < ActiveSupport::TestCase
  should 'generate proper configuration for UoT' do
    load_mp('marketplaces/uot')
    form_component = FormComponent.new(form_fields: form_component_fields)
    assert_equal buyer_form_configuration, FormComponentToFormConfiguration.new(Instance.where(id: PlatformContext.current.instance.id)).send(:build_configuration_based_on_form_components, form_component, 'buyer')

    assert_equal seller_form_configuration, FormComponentToFormConfiguration.new(Instance.where(id: PlatformContext.current.instance.id)).send(:build_configuration_based_on_form_components, form_component, 'seller')
  end

  should 'generate proper configuration for dummy MP' do
    load_mp('test/assets/dummy_marketplace')
    form_component = FormComponent.new(form_fields: [{"buyer"=>"photo_input"}])
    assert_equal dummy_mp_buyer_form_configuration, FormComponentToFormConfiguration.new(Instance.where(id: PlatformContext.current.instance.id)).send(:build_configuration_based_on_form_components, form_component, 'buyer')
  end

  protected

  def load_mp(path)
    MarketplaceBuilder::Loader.load(path,
                                    verbose: false,
                                    instance_id: PlatformContext.current.instance.id,
                                    creators: [
                                      MarketplaceBuilder::Creators::MarketplaceCreator,
                                      MarketplaceBuilder::Creators::TransactableTypesCreator,
                                      MarketplaceBuilder::Creators::InstanceProfileTypesCreator,
                                      MarketplaceBuilder::Creators::CategoriesCreator,
                                      MarketplaceBuilder::Creators::CustomModelTypesCreator
                                    ])
  end

  def dummy_mp_buyer_form_configuration
    {:profiles=>{:buyer=>{:validation=>{:presence=>{}}, :custom_images=>{"photo_input"=>{:validation=>{:presence=>{}}}, :validation=>{:presence=>{}}}}}}
  end

  def buyer_form_configuration
    {
      profiles: {
        :buyer => {
          :validation => {
            presence: {}
          },
          'enabled' => {},
          :properties => {
            :validation => {
              presence: {}
            },
            'referred_by_sme' => {},
            'linkedin_url' => {
              validation: {
                presence: {}
              }
            },
            'hourly_rate_decimal' => {
              validation: {
                presence: {}
              }
            },
            'workplace_type' => {
              validation: {}
            },
            'discounts_available' => {
              validation: {}
            },
            'discounts_description' => {},
            'travel' => {
              validation: {}
            },
            'cities' => {},
            'bio' => {
              validation: {
                presence: {}
              }
            },
            'education' => {},
            'awards' => {},
            'pro_service' => {},
            'teaching' => {},
            'employers' => {},
            'accomplishments' => {},
            'giving_back' => {},
            'hobbies' => {},
            'availability' => {}
          },
          :categories => {
            :validation => {
              presence: {}
            },
            'Area Of Expertise' => {
              validation: {}
            },
            'Industry' => {
              validation: {}
            },
            'Languages' => {
              validation: {}
            }
          },
          :customizations => {
            :validation => {
              presence: {}
            },
            'links' => {
              properties: {
                'url_link' => {
                  validation: {
                    presence: {}
                  }
                }
              }
            },
            'recommendations' => {
              properties: {
                'author' => {
                  validation: {
                    presence: {}
                  }
                },
                'recommendation' => {
                  validation: {
                    presence: {}
                  }
                }
              }
            }
          }
        },
        :default => {
          validation: {
            presence: {}
          }
        }
      },
      'name' => {
        validation: {
          presence: {}
        }
      },
      'avatar' => {
        validation: {
          presence: {}
        }
      },
      :current_address => {
        address: { validation: { presence: {} } },
        should_check_address: {},
        local_geocoding: {},
        latitude: {},
        longitude: {},
        formatted_addres: {},
        street: {},
        suburb: {},
        city: {},
        state: {},
        country: {},
        postcode: {},
        address_components: {},
        validation: { presence: {} }
      },
      'country_name' => {},
      'mobile_number' => {},
      'tag_list' => {},
      password_confirmation: { property_options: { virtual: true }, validation: { confirm: {} } }
    }
  end

  def seller_form_configuration
    {
      'name' => {
        validation: {
          presence: {}
        }
      },
      'avatar' => {
        validation: {
          presence: {}
        }
      },
      :current_address => {
        address: { validation: { presence: {} } },
        should_check_address: {},
        local_geocoding: {},
        latitude: {},
        longitude: {},
        formatted_addres: {},
        street: {},
        suburb: {},
        city: {},
        state: {},
        country: {},
        postcode: {},
        address_components: {},
        validation: { presence: {} }
      },
      'country_name' => {},
      'mobile_number' => { validation: { presence: {} } },
      profiles: {
        :default => {
          validation: {
            presence: {}
          }
        },
        :seller => {
          validation: {
            presence: {}
          },
          properties: {
            :validation => {
              presence: {}
            },
            'linkedin_url' => {
              validation: {
                presence: {}
              }
            }
          }
        },
      },
      "company_name" => {},
      password_confirmation: { property_options: { virtual: true }, validation: { confirm: {} } }
    }
  end

  def form_component_fields
    [
      { 'buyer' => 'enabled' },
      { 'user' => 'name' },
      { 'user' => 'avatar' },
      { 'user' => 'email' },
      { 'user' => 'current_address' },
      { 'user' => 'mobile_phone' },
      { 'buyer' => 'referred_by_sme' },
      { 'buyer' => 'linkedin_url' },
      { 'buyer' => 'hourly_rate_decimal' },
      { 'user' => 'buyer_hourly_rate_decimal' },
      { 'buyer' => 'workplace_type' },
      { 'buyer' => 'discounts_available' },
      { 'buyer' => 'discounts_description' },
      { 'buyer' => 'travel' },
      { 'buyer' => 'cities' },
      { 'buyer' => 'Category - Area Of Expertise' },
      { 'buyer' => 'Category - Industry' },
      { 'buyer' => 'Category - Languages' },
      { 'buyer' => 'bio' },
      { 'buyer' => 'education' },
      { 'buyer' => 'awards' },
      { 'buyer' => 'pro_service' },
      { 'buyer' => 'teaching' },
      { 'buyer' => 'Custom Model - Links' },
      { 'buyer' => 'employers' },
      { 'buyer' => 'accomplishments' },
      { 'buyer' => 'giving_back' },
      { 'buyer' => 'hobbies' },
      { 'buyer' => 'availability' },
      { 'buyer' => 'tags' },
      { 'buyer' => 'Custom Model - Recommendations' },
      { 'seller' => 'linkedin_url' },
      { 'seller' => 'company_name' },
      { 'user' => 'password' }
    ]
  end
end
