class TransactableType < ActiveRecord::Base
  has_paper_trail
  acts_as_paranoid
  auto_set_platform_context
  scoped_to_platform_context

  acts_as_custom_attributes_set

  MAX_PRICE = 2147483647
  AVAILABLE_TYPES = ['Listing', 'Buy/Sell']

  attr_accessor :enable_cancellation_policy

  has_many :transactables, inverse_of: :transactable_type
  has_many :availability_templates, inverse_of: :transactable_type, :dependent => :destroy
  has_many :data_uploads, inverse_of: :transactable_type
  has_many :transactable_type_actions
  has_many :action_types, through: :transactable_type_actions
  has_many :form_components
  has_many :rating_systems
  has_many :reviews
  has_many :instance_views

  has_one :schedule, as: :scheduable
  accepts_nested_attributes_for :schedule

  belongs_to :instance

  # serialize :pricing_options, Hash
  serialize :pricing_validation, Hash
  serialize :availability_options, Hash
  serialize :custom_csv_fields, Array

  before_save :normalize_cancellation_policy_enabled
  after_save :setup_availability_attributes, :if => lambda { |transactable_type| transactable_type.availability_options_changed? && transactable_type.availability_options.present? }

  validates_presence_of :name
  validate :pricing_validation_is_correct
  validate :availability_options_are_correct
  validates_presence_of :cancellation_policy_hours_for_cancellation, :cancellation_policy_penalty_percentage, if: lambda { |transactable_type| transactable_type.enable_cancellation_policy }
  validates_inclusion_of :cancellation_policy_penalty_percentage, in: 0..100, allow_nil: true, message: 'must be between 0 and 100', if: lambda { |transactable_type| transactable_type.enable_cancellation_policy }

  accepts_nested_attributes_for :availability_templates

  def any_rating_system_active?
    self.rating_systems.any?(&:active)
  end

  def normalize_cancellation_policy_enabled
    if self.enable_cancellation_policy == "1"
      self.cancellation_policy_enabled ||= Time.zone.now
    else
      self.cancellation_policy_enabled = nil
    end
  end

  def defer_availability_rules?
    availability_options && availability_options["defer_availability_rules"]
  end

  def pricing_options_long_period_names
    pricing_options = []
    pricing_options << "daily" if action_daily_booking
    pricing_options << "weekly" if action_weekly_booking
    pricing_options << "monthly" if action_monthly_booking
    pricing_options
  end

  def pricing_validation_is_correct
    self.pricing_validation.each do |price, pair|
      if pair["min"].present? && pair["max"].present?
        errors.add("pricing_validation[#{price}]['min']", "min can't be greater than max") if pair["min"].to_i > pair["max"].to_i
      end
      errors.add("pricing_validation[#{price}]['min']", "min can't be lower than zero") if pair["min"].present? && pair["min"].to_i < 0
      errors.add("pricing_validation[#{price}]['max']", "max can't be greater than #{MAX_PRICE}") if pair["max"].present? && pair["max"].to_i > MAX_PRICE
    end
  end

  def availability_options_are_correct
    errors.add("availability_options[confirm_reservations][public]", "must be set") if availability_options["confirm_reservations"]["public"].nil?
    errors.add("availability_options[confirm_reservations][default_value]", "must be set") if availability_options["confirm_reservations"]["default_value"].nil?
  rescue
    errors.add("availability_options[confirm_reservations][public]", "must be set")
    errors.add("availability_options[confirm_reservations][default_value]", "must be set")
  end

  def build_validation_rule_for(price)
    @greater_than = 0
    @less_than = MAX_PRICE
    if pricing_validation[price].present?
      @greater_than = pricing_validation[price]["min"].to_i if pricing_validation[price]["min"].present?
      @less_than = pricing_validation[price]["max"].to_i if pricing_validation[price]["max"].present?
    end
    { :numericality => { redirect: "#{price}_price", allow_nil: true, greater_than_or_equal_to: @greater_than, less_than_or_equal_to: @less_than } }
  end

  def setup_availability_attributes
    tta = custom_attributes.where(:name => :confirm_reservations).first.presence || custom_attributes.build(name: :confirm_reservations, internal: true)
    tta.attributes = { attribute_type: "boolean", html_tag: "switch", default_value: availability_options["confirm_reservations"]["default_value"], public: availability_options["confirm_reservations"]["public"], validation_rules: self.class.mandatory_boolean_validation_rules }
    tta.save!
  end

  def self.mandatory_boolean_validation_rules
    { "inclusion" => { "in" => [true, false], "allow_nil" => false } }
  end

  def buy_sell?
    name == 'Buy/Sell'
  end

  def to_liquid
    TransactableTypeDrop.new(self)
  end

  def has_action?(name)
    @action_type_names ||= action_types.pluck(:name)
    @action_type_names.include?(name)
  end

  def bookable_noun_plural
    (bookable_noun.presence || name).pluralize
  end

end

