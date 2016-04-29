class FormComponent < ActiveRecord::Base
  has_paper_trail
  acts_as_paranoid
  auto_set_platform_context
  scoped_to_platform_context

  SPACE_WIZARD = 'space_wizard'
  PRODUCT_ATTRIBUTES = 'product_attributes'
  PROJECT_ATTRIBUTES = 'project_attributes'
  OFFER_ATTRIBUTES = 'offer_attributes'
  RESERVATION_ATTRIBUTES = 'reservation_attributes'
  TRANSACTABLE_ATTRIBUTES = 'transactable_attributes'
  INSTANCE_PROFILE_TYPES = 'instance_profile_types'
  SELLER_PROFILE_TYPES = 'seller_profile_types'
  BUYER_PROFILE_TYPES = 'buyer_profile_types'
  DEFAULT_REGISTRATION = 'default_registration'
  SELLER_REGISTRATION = 'seller_registration'
  BUYER_REGISTRATION = 'buyer_registration'
  FORM_TYPES = [
    SPACE_WIZARD, PRODUCT_ATTRIBUTES, TRANSACTABLE_ATTRIBUTES, INSTANCE_PROFILE_TYPES,
    PROJECT_ATTRIBUTES, BUYER_PROFILE_TYPES, SELLER_PROFILE_TYPES, OFFER_ATTRIBUTES,
    RESERVATION_ATTRIBUTES, DEFAULT_REGISTRATION, BUYER_REGISTRATION, SELLER_REGISTRATION
  ]

  include RankedModel

  belongs_to :form_componentable, -> { with_deleted }, polymorphic: true, touch: true
  belongs_to :instance
  validates_inclusion_of :form_type, in: FORM_TYPES, allow_nil: false
  validates_length_of :name, maximum: 255

  serialize :form_fields, Array

  ranks :rank, with_same: [:form_componentable_id, :form_type]

  def fields_names
    form_fields.inject([]) do |all_fields_names, field|
      all_fields_names << field[field.keys.first]
      all_fields_names
    end
  end

  def form_types(form_componentable)
    if form_componentable.instance_of?(InstanceProfileType)
      case form_componentable.profile_type
      when InstanceProfileType::DEFAULT
        [INSTANCE_PROFILE_TYPES, DEFAULT_REGISTRATION]
      when InstanceProfileType::SELLER
        [SELLER_PROFILE_TYPES, SELLER_REGISTRATION]
      when InstanceProfileType::BUYER
        [BUYER_PROFILE_TYPES, BUYER_REGISTRATION]
      else
        raise NotImplementedError
      end
    elsif form_componentable.instance_of?(ServiceType)
      [SPACE_WIZARD, TRANSACTABLE_ATTRIBUTES]
    elsif form_componentable.instance_of?(Spree::ProductType)
      [SPACE_WIZARD, PRODUCT_ATTRIBUTES]
    elsif form_componentable.instance_of?(ProjectType)
      [SPACE_WIZARD, PROJECT_ATTRIBUTES]
    elsif form_componentable.instance_of?(OfferType)
      [SPACE_WIZARD, OFFER_ATTRIBUTES]
    elsif form_componentable.instance_of?(ReservationType)
      [RESERVATION_ATTRIBUTES]
    else
      raise NotImplementedError
    end
  end
end

