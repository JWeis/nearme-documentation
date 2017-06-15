# A template which assigns a set of standard AvailabilityRules to a target.
class AvailabilityTemplate < ActiveRecord::Base
  auto_set_platform_context
  scoped_to_platform_context

  has_many :availability_rules, as: :target, inverse_of: :target, dependent: :destroy
  has_many :schedule_exception_rules, dependent: :destroy

  belongs_to :transactable_type
  belongs_to :instance
  has_many :transactables
  belongs_to :parent, polymorphic: true, touch: true, inverse_of: :availability_templates

  # attr_accessible :transactable_type, :name, :description, :availability_rules, :availability_rules_attributes

  accepts_nested_attributes_for :availability_rules, allow_destroy: true
  accepts_nested_attributes_for :schedule_exception_rules, allow_destroy: true

  before_validation :validate_schedule_rules
  validates_associated :schedule_exception_rules

  # AR can't handle parent: [different_objects] condition.
  scope :for_parents, lambda  { |parents|
    parents.compact!
    types = parents.group_by(&:class)
    if types.one?
      where(parent: parents)
    else
      conditions = []
      types.each_pair do |type, objects|
        conditions << send(:sanitize_sql_array, ['(parent_id in (?) AND parent_type = ?)', objects, type])
      end
      where(conditions.join(' OR '))
    end
  }

  def future_availability_exceptions
    schedule_exception_rules.future
  end

  def full_name
    "#{name} (#{description})"
  end

  def minimum_booking_hours
    parent.respond_to?(:minimum_booking_minutes) || 1
  end

  def availability
    @summary ||= AvailabilityRule::Summary.new(availability_rules)
  end

  def custom?
    parent_type.in? ['Location', 'Transactable::TimeBasedBooking', 'Transactable', 'UserProfile']
  end

  def custom_for_location?
    parent_type == 'Location'
  end

  def custom_for_object?
    ['Transactable', 'UserProfile', 'Transactable::TimeBasedBooking'].include? parent_type
  end

  def time_zone
    parent.respond_to?(:time_zone) ? parent.time_zone : nil
  end

  def validate_schedule_rules
    return true if schedule_exception_rules.blank?

    Time.use_zone(time_zone) do
      schedule_exception_rules.each(&:parse_user_input)
    end
  end
end
