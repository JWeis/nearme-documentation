class TransactableType < ActiveRecord::Base
  self.inheritance_column = :type
  has_paper_trail
  acts_as_paranoid
  auto_set_platform_context
  scoped_to_platform_context
  acts_as_custom_attributes_set

  AVAILABLE_TYPES = ['Listing', 'Buy/Sell']

  INTERNAL_FIELDS = [
    :name, :description, :capacity, :quantity, :confirm_reservations,
    :last_request_photos_sent_at, :capacity
  ]

  attr_accessor :enable_cancellation_policy

  has_many :form_components, as: :form_componentable
  has_many :data_uploads, as: :importable, dependent: :destroy
  has_many :rating_systems
  has_many :reviews
  has_many :instance_views
  has_many :categories, as: :categorizable, dependent: :destroy
  has_many :custom_validators, as: :validatable

  belongs_to :instance

  serialize :custom_csv_fields, Array
  serialize :allowed_currencies, Array
  serialize :availability_options, Hash

  after_update :destroy_translations!, if: lambda { |transactable_type| transactable_type.name_changed? || transactable_type.bookable_noun_changed? || transactable_type.lessor_changed? || transactable_type.lessee_changed? }
  after_create :create_translations!

  validates_presence_of :name

  scope :products, -> { where(type: 'Spree::ProductType') }
  scope :services, -> { where(type: 'ServiceType') }

  delegate :translation_namespace, :translation_namespace_was, :translation_key_suffix, :translation_key_suffix_was,
    :translation_key_pluralized_suffix, :translation_key_pluralized_suffix_was, :underscore, to: :translation_manager

  def any_rating_system_active?
    self.rating_systems.any?(&:active)
  end

  def allowed_currencies
    super || instance.allowed_currencies
  end

  def allowed_currencies=currencies
    currencies.reject!(&:blank?)
    super(currencies)
  end

  def default_currency
    super.presence || instance.default_currency
  end

  def translated_bookable_noun(count = 1)
    translation_manager.find_key_with_count('name', count)
  end

  def translated_lessor(count = 1)
    translation_manager.find_key_with_count('lessor', count)
  end

  def translated_lessee(count = 1)
    translation_manager.find_key_with_count('lessee', count)
  end

  def create_translations!
    translation_manager.create_translations!
  end

  def destroy_translations!
    translation_manager.destroy_translations!
  end

  def self.mandatory_boolean_validation_rules
    { "inclusion" => { "in" => [true, false], "allow_nil" => false } }
  end

  def translation_manager
    @translation_manager ||= TransactableType::TransactableTypeTranslationManager.new(self)
  end

  def to_liquid
    raise NotImplementedError.new('Abstract method')
  end

  def has_action?(name)
    action_rfq?
  end

  def create_rating_systems
    RatingConstants::RATING_SYSTEM_SUBJECTS.each do |subject|
      rating_system = self.rating_systems.create!(subject: subject)
      RatingConstants::VALID_VALUES.each { |value| rating_system.rating_hints.create!(value: value) }
    end
  end

end

