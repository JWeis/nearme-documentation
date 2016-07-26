class Transactable < ActiveRecord::Base
  has_paper_trail
  acts_as_paranoid
  auto_set_platform_context
  scoped_to_platform_context

  include Impressionable
  include Searchable
  # FIXME disabled Sitemap updates. Needs to be optimized.
  # include SitemapService::Callbacks
  include SellerAttachments
    # == Helpers
  include Listing::Search
  include Categorizable
  include Approvable

  DEFAULT_ATTRIBUTES = %w(name description capacity)

  SORT_OPTIONS = ['All', 'Featured', 'Most Recent', 'Most Popular', 'Collaborators']

  DATE_VALUES = ['today', 'yesterday', 'week_ago', 'month_ago', '3_months_ago', '6_months_ago']

  RENTAL_SHIPPING_TYPES = %w(no_rental delivery pick_up both).freeze

  PRICE_TYPES = [:hourly, :weekly, :daily, :monthly, :fixed, :exclusive, :weekly_subscription, :monthly_subscription]

  # This must go before has_custom_attributes because of how the errors for the custom
  # attributes are added to the instance
  include CommunityValidators
  has_custom_attributes target_type: 'TransactableType', target_id: :transactable_type_id
  has_metadata accessors: [:photos_metadata]
  inherits_columns_from_association([:company_id, :administrator_id, :creator_id, :listings_public], :location)

  include CreationFilter
  include QuerySearchable

  has_many :customizations, as: :customizable
  has_many :additional_charge_types, as: :additional_charge_type_target
  has_many :availability_templates, as: :parent
  has_many :approval_requests, as: :owner, dependent: :destroy
  has_many :amenity_holders, as: :holder, dependent: :destroy, inverse_of: :holder
  has_many :amenities, through: :amenity_holders, inverse_of: :listings
  has_many :assigned_waiver_agreement_templates, as: :target
  has_many :billing_authorizations, as: :reference
  has_many :document_requirements, as: :item, dependent: :destroy, inverse_of: :item
  has_many :inquiries, inverse_of: :listing
  has_many :impressions, :as => :impressionable, :dependent => :destroy
  has_many :photos, as: :owner, dependent: :destroy do
    def thumb
      (first || build).thumb
    end

    def except_cover
      offset(1)
    end
  end
  has_many :attachments, -> { order(:id) }, class_name: 'SellerAttachment', as: :assetable
  has_many :recurring_bookings, inverse_of: :transactable
  has_many :orders
  has_many :reservations
  has_many :old_reservations
  has_many :transactable_tickets, as: :target, class_name: 'Support::Ticket'
  has_many :user_messages, as: :thread_context, inverse_of: :thread_context
  has_many :waiver_agreement_templates, through: :assigned_waiver_agreement_templates
  has_many :wish_list_items, as: :wishlistable
  has_many :billing_authorizations, as: :reference
  has_many :inappropriate_reports, as: :reportable, dependent: :destroy
  has_many :action_types, inverse_of: :transactable
  has_many :data_source_contents, through: :transactable_topics
  belongs_to :transactable_type, -> { with_deleted }
  belongs_to :company, -> { with_deleted }, inverse_of: :listings
  belongs_to :location, -> { with_deleted }, inverse_of: :listings, touch: true
  belongs_to :instance, inverse_of: :listings
  belongs_to :creator, -> { with_deleted }, class_name: "User", inverse_of: :listings
  counter_culture :creator,
    column_name: -> (t) { t.draft.nil? ? 'transactables_count' : nil },
    column_names: { ["transactables.draft IS NULL AND transactables.deleted_at IS NULL"] => 'transactables_count' }

  belongs_to :administrator, -> { with_deleted }, class_name: "User", inverse_of: :administered_listings
  has_one :dimensions_template, as: :entity

  has_one :location_address, through: :location
  has_one :upload_obligation, as: :item, dependent: :destroy
  belongs_to :event_booking, foreign_key: :action_type_id
  belongs_to :subscription_booking, foreign_key: :action_type_id
  belongs_to :time_based_booking, foreign_key: :action_type_id
  belongs_to :no_action_booking, foreign_key: :action_type_id
  belongs_to :purchase_action, foreign_key: :action_type_id
  belongs_to :action_type
  belongs_to :shipping_profile

  has_many :activity_feed_events, as: :followed, dependent: :destroy
  has_many :activity_feed_subscriptions, as: :followed, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :feed_followers, through: :activity_feed_subscriptions, source: :follower
  has_many :links, dependent: :destroy, as: :linkable
  has_many :transactable_topics, dependent: :destroy
  has_many :topics, through: :transactable_topics
  has_many :approved_transactable_collaborators, -> { approved }, class_name: 'TransactableCollaborator', dependent: :destroy
  has_many :collaborating_users, through: :approved_transactable_collaborators, source: :user
  has_many :transactable_collaborators, dependent: :destroy
  has_many :group_transactables, dependent: :destroy
  has_many :groups, through: :group_transactables

  has_many :activity_feed_events, as: :followed, dependent: :destroy
  has_many :activity_feed_subscriptions, as: :followed, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :feed_followers, through: :activity_feed_subscriptions, source: :follower
  has_many :links, dependent: :destroy, as: :linkable
  has_many :transactable_topics, dependent: :destroy
  has_many :topics, through: :transactable_topics
  has_many :approved_transactable_collaborators, -> { approved }, class_name: 'TransactableCollaborator', dependent: :destroy
  has_many :collaborating_users, through: :approved_transactable_collaborators, source: :user
  has_many :transactable_collaborators, dependent: :destroy
  has_many :group_transactables, dependent: :destroy
  has_many :groups, through: :group_transactables

  accepts_nested_attributes_for :additional_charge_types, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :approval_requests
  accepts_nested_attributes_for :attachments, allow_destroy: true
  accepts_nested_attributes_for :dimensions_template, allow_destroy: true
  accepts_nested_attributes_for :document_requirements, allow_destroy: true, reject_if: :document_requirement_hidden?
  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :upload_obligation
  accepts_nested_attributes_for :waiver_agreement_templates, allow_destroy: true
  accepts_nested_attributes_for :customizations, allow_destroy: true
  accepts_nested_attributes_for :action_types, allow_destroy: true
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  # == Callbacks
  before_destroy :decline_reservations
  before_save :set_currency
  before_save :set_is_trusted, :set_available_actions
  before_validation :set_activated_at, :set_enabled, :set_confirm_reservations,
    :set_possible_payout, :set_action_type
  after_create :set_external_id
  after_save do
    if availability.try(:days_open).present?
      self.update_column(:opened_on_days, availability.days_open.sort)
    end
    true
  end
  after_destroy :close_request_for_quotes
  after_destroy :fix_counter_caches
  after_destroy :fix_counter_caches_after_commit

  before_restore :restore_photos
  before_restore :restore_links
  before_restore :restore_transactable_collaborators

  after_commit :user_created_transactable_event, on: :create, unless: ->(record) { record.draft? || record.skip_activity_feed_event }
  def user_created_transactable_event
    event = :user_created_transactable
    user = self.creator.try(:object).presence || self.creator
    affected_objects = [user] + self.topics
    ActivityFeedService.create_event(event, self, affected_objects, self)
  end
  after_update :user_created_transactable_event_on_publish, unless: ->(record) { record.skip_activity_feed_event }
  def user_created_transactable_event_on_publish
    if draft_changed?
      user_created_transactable_event
    end
  end

  # == Scopes
  scope :purchasable, -> { joins(:action_type).where("transactable_action_types.enabled = true AND transactable_action_types.type = 'Transactable::PurchaseAction'") }
  scope :featured, -> { where(featured: true) }
  scope :draft, -> { where('transactables.draft IS NOT NULL') }
  scope :active, -> { where('transactables.draft IS NULL') }
  scope :latest, -> { order("transactables.created_at DESC") }
  scope :visible, -> { where(:enabled => true) }
  scope :searchable, -> { require_payout? ? active.visible.with_possible_payout : active.visible }
  scope :with_possible_payout, -> { where(possible_payout: true)}
  scope :without_possible_payout, -> { where(possible_payout: false) }
  scope :for_transactable_type_id, -> transactable_type_id { where(transactable_type_id: transactable_type_id) }
  scope :for_groupable_transactable_types, -> { joins(:transactable_type).where('transactable_types.groupable_with_others = ?', true) }
  scope :filtered_by_price_types, -> price_types { where([(price_types - ['free']).map { |pt| "#{pt}_price_cents IS NOT NULL" }.join(' OR '),
                                                          ("transactables.action_free_booking=true" if price_types.include?('free'))].reject(&:blank?).join(' OR ')) }
  scope :filtered_by_custom_attribute, -> (property, values) { where("string_to_array((transactables.properties->?), ',') && ARRAY[?]", property, values) unless values.blank? }

  scope :not_booked_relative, -> (start_date, end_date) {
    joins(ActiveRecord::Base.send(:sanitize_sql_array, ['LEFT OUTER JOIN (
       SELECT MIN(qty) as min_qty, transactable_id, count(*) as number_of_days_booked
       FROM (SELECT SUM(orders.quantity) as qty, orders.transactable_id, reservation_periods.date
         FROM "orders"
         INNER JOIN "reservation_periods" ON "reservation_periods"."reservation_id" = "orders"."id"
         WHERE
          "orders"."instance_id" = ? AND
          COALESCE("orders"."booking_type", \'daily\') != \'hourly\' AND
          "orders"."deleted_at" IS NULL AND
          "orders"."state" NOT IN (\'cancelled_by_guest\',\'cancelled_by_host\',\'rejected\',\'expired\') AND
          "reservation_periods"."date" BETWEEN ? AND ?
         GROUP BY reservation_periods.date, orders.transactable_id) AS spots_taken_per_transactable_per_date
       GROUP BY transactable_id
       ) as min_spots_taken_per_transactable_during_date_period ON min_spots_taken_per_transactable_during_date_period.transactable_id = transactables.id', PlatformContext.current.instance.id, start_date.to_s, end_date.to_s]))
      .where('(COALESCE(min_spots_taken_per_transactable_during_date_period.min_qty, 0) < transactables.quantity OR min_spots_taken_per_transactable_during_date_period.number_of_days_booked <= ?)', (end_date - start_date).to_i)
  }

  scope :not_booked_absolute, -> (start_date, end_date) {
    joins(ActiveRecord::Base.send(:sanitize_sql_array, ['LEFT OUTER JOIN (
       SELECT MAX(qty) as max_qty, transactable_id
       FROM (SELECT SUM(orders.quantity) as qty, orders.transactable_id, reservation_periods.date
         FROM "orders"
         INNER JOIN "reservation_periods" ON "reservation_periods"."reservation_id" = "orders"."id"
         WHERE
          "orders"."instance_id" = ? AND
          "orders"."deleted_at" IS NULL AND
          "orders"."state" NOT IN (\'cancelled_by_guest\',\'cancelled_by_host\',\'rejected\',\'expired\') AND
          "reservation_periods"."date" BETWEEN ? AND ?
         GROUP BY reservation_periods.date, orders.transactable_id) AS spots_taken_per_transactable_per_date
       GROUP BY transactable_id
       ) as min_spots_taken_per_transactable_during_date_period ON min_spots_taken_per_transactable_during_date_period.transactable_id = transactables.id', PlatformContext.current.instance.id, start_date.to_s, end_date.to_s]))
      .where('COALESCE(min_spots_taken_per_transactable_during_date_period.max_qty, 0) < transactables.quantity')
  }

  # see http://www.postgresql.org/docs/9.4/static/functions-array.html
  scope :only_opened_on_at_least_one_of, -> (days) {
    # check overlap -> && operator
    # for now only regular booking are supported - fixed price transactables are just returned
    where('? = ANY (transactables.available_actions) OR transactables.opened_on_days @> \'{?}\'', 'event', days)
  }

  scope :only_opened_on_all_of, -> (days) {
    # check if opened_on_days contains days -> @> operator
    # for now only regular booking are supported - fixed price transactables are just returned
    where('? = ANY (transactables.available_actions) OR transactables.opened_on_days @> \'{?}\'', 'event', days)
  }

  #TODO change schedule
  scope :overlaps_schedule_start_date, -> (date) {
    where("
      ((select count(*) from schedules where scheduable_id = transactables.id and scheduable_type = '#{self.to_s}' limit 1) = 0)
      OR
      (?::timestamp::date >= (select sr_start_datetime from schedules where scheduable_id = transactables.id and scheduable_type = '#{self.to_s}' limit 1)::timestamp::date)", date)
  }

  scope :order_by_array_of_ids, -> (listing_ids) {
    listing_ids_decorated = listing_ids.each_with_index.map {|lid, i| "WHEN transactables.id=#{lid} THEN #{i}" }
    order("CASE #{listing_ids_decorated.join(' ')} END") if listing_ids.present?
  }

  scope :with_date, ->(date) { where(created_at: date) }
  scope :by_topic, -> (topic_ids) { includes(:transactable_topics).where(transactable_topics: {topic_id: topic_ids}) if topic_ids.present?}
  scope :seek_collaborators, -> { where(seek_collaborators: true) }
  scope :feed_not_followed_by_user, -> (current_user) {
    where.not(id: current_user.feed_followed_transactables.pluck(:id))
  }

  # == Validations
  validates_with CustomValidators

  validates :currency, presence: true, allow_nil: false, currency: true
  validates :transactable_type, :action_type, presence: true
  validates :location, presence: true, unless: ->(record) { record.location_not_required }
  validates :photos, length: {:minimum => 1}, unless: ->(record) { record.photo_not_required || !record.transactable_type.enable_photo_required }
  validates :quantity, presence: true, numericality: {greater_than: 0}, unless: ->(record) { record.action_type.is_a?(Transactable::PurchaseAction) }

  #TODO probably move to concern as different actions can be shipped
  validates :rental_shipping_type, inclusion: { in: RENTAL_SHIPPING_TYPES }
  validates_presence_of :dimensions_template, if: lambda { |record| ['delivery', 'both'].include?(record.rental_shipping_type) }
  validates :topics, length: { minimum: 1 }, if: ->(record) { record.topics_required && !record.draft.present? }

  validates_associated :approval_requests, :action_type
  validates :name, length: { maximum: 255 }, allow_blank: true

  after_save :trigger_workflow_alert_for_added_collaborators, unless: ->(record) { record.draft? }

  delegate :latitude, :longitude, :postcode, :city, :suburb, :state, :street, :country, to: :location_address, allow_nil: true

  delegate :name, :description, to: :company, prefix: true, allow_nil: true
  delegate :url, to: :company
  delegate :formatted_address, :local_geocoding, :distance_from, :address, :postcode, :administrator=, to: :location, allow_nil: true
  delegate :service_fee_guest_percent, :service_fee_host_percent, :hours_to_expiration, :hours_for_guest_to_confirm_payment,
    :custom_validators, :show_company_name, :display_additional_charges?, to: :transactable_type
  delegate :name, to: :creator, prefix: true
  delegate :to_s, to: :name
  delegate :favourable_pricing_rate, to: :transactable_type
  delegate :schedule_availability, :next_available_occurrences, :book_it_out_available?,
    :exclusive_price_available?, :only_exclusive_price_available?, to: :event_booking, allow_nil: true
  delegate :first_available_date, :second_available_date, :availability_exceptions,
    :custom_availability_template?, :availability, :overnight_booking?, to: :time_based_booking, allow_nil: true
  delegate :open_on?, :open_now?, :bookable?, :has_price?, :hours_to_expiration, to: :action_type, allow_nil: true

  attr_accessor :distance_from_search_query, :photo_not_required, :enable_monthly,
    :enable_weekly, :enable_daily, :enable_hourly, :skip_activity_feed_event,
    :enable_weekly_subscription,:enable_monthly_subscription, :enable_deposit_amount,
    :scheduled_action_free_booking, :regular_action_free_booking, :location_not_required,
    :topics_required

  monetize :insurance_value_cents, with_model_currency: :currency, allow_nil: true
  monetize :deposit_amount_cents, with_model_currency: :currency, allow_nil: true

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders, :scoped], scope: :instance
  def slug_candidates
    [
      :name,
      [:name, self.class.last.try(:id).to_i + 1],
      [:name, rand(1000000)]
    ]
  end

  def self.require_payout?
    return false unless current_instance
    !current_instance.test_mode? && current_instance.require_payout_information?
  end

  def self.current_instance
    PlatformContext.current.try(:instance)
  end

  def availability_template
    time_based_booking.try(:availability_template) || location.try(:availability_template)
  end

  def validation_for(field_names)
    custom_validators.where(field_name: field_names)
  end

  def set_is_trusted
    self.enabled = self.enabled && is_trusted?
    true
  end

  def set_available_actions
    self.available_actions = action_type.pricings.pluck(:unit).uniq if action_type
  end

  def availability_for(date, start_min = nil, end_min = nil)
    if open_on?(date, start_min, end_min)
      # Return the number of free desks
      [self.quantity - desks_booked_on(date, start_min, end_min), 0].max
    else
      0
    end
  end

  # Maximum quantity available for a given date
  def quantity_for(date)
    self.quantity
  end

  def administrator
    super.presence || creator
  end

  #TODO rental shipping
  def rental_shipping_type
    transactable_type.rental_shipping ? super : 'no_rental'
  end

  def desks_booked_on(date, start_minute = nil, end_minute = nil)
    scope = orders.confirmed.joins(:periods).where(:reservation_periods => {:date => date})

    if start_minute
      hourly_conditions = []
      hourly_values = []
      hourly_conditions << "(reservation_periods.start_minute IS NULL AND reservation_periods.end_minute IS NULL)"

      [start_minute, end_minute].compact.each do |minute|
        hourly_conditions << "(? BETWEEN reservation_periods.start_minute AND reservation_periods.end_minute)"
        hourly_values << minute
      end

      scope = scope.where(hourly_conditions.join(' OR '), *hourly_values)
    end

    scope.sum(:quantity)
  end

  def all_prices
    @all_prices ||= action_type ? action_type.pricings.map{ |p| p.is_free_booking? ? 0 : p.price_cents } : []
  end

  def lowest_price_with_type(price_types = [])
    action_type.pricings_for_types(price_types).sort_by(&:price).first
  end

  # TODO: remove lowest_price_with_type or ideally move this to decorator
  def lowest_price(available_price_types = [])
    lowest_price_with_type(available_price_types)
  end

  def lowest_full_price(available_price_types = [])
    lowest_full_price = nil
    lowest_price = lowest_price_with_type(available_price_types)

    if lowest_price.present?
      full_price_cents = lowest_price.price

      if !service_fee_guest_percent.to_f.zero?
        full_price_cents = full_price_cents * (1 + service_fee_guest_percent / 100.0)
      end

      full_price_cents += Money.new(AdditionalChargeType.where(status: 'mandatory').sum(:amount_cents), full_price_cents.currency.iso_code)
      lowest_price.price = full_price_cents
    end

    lowest_price
  end

  def created_by?(user)
    user && user.admin? || user == creator
  end

  def inquiry_from!(user, attrs = {})
    inquiries.build(attrs).tap do |i|
      i.inquiring_user = user
      i.save!
    end
  end

  def has_photos?
    photos_metadata.try(:count).to_i > 0
  end

  def reserve!(reserving_user, dates, quantity, pricing = action_type.pricings.first)
    payment_method  = PaymentMethod.manual.first
    reservation = Reservation.new(
      user: reserving_user,
      owner: reserving_user,
      quantity: quantity,
      transactable_pricing: pricing,
      transactable: self,
      currency: self.currency
    )
    reservation.build_payment(reservation.shared_payment_attributes.merge({ payment_method: payment_method }))
    dates.each do |date|
      raise ::DNM::PropertyUnavailableOnDate.new(date, quantity) unless available_on?(date, quantity)
      reservation.add_period(date)
    end
    reservation.save!
    reservation.activate!
    reservation
  end

  def dates_fully_booked
    orders.map(:date).select { |d| fully_booked_on?(date) }
  end

  def fully_booked_on?(date)
    open_on?(date) && !available_on?(date)
  end

  # TODO price per unit
  def available_on?(date, quantity=1, start_min = nil, end_min = nil)
    quantity = 1 if transactable_type.action_price_per_unit?
    availability_for(date, start_min, end_min) >= quantity
  end

  def all_additional_charge_types_ids
    (additional_charge_types + transactable_type.try(:additional_charge_types) + instance.additional_charge_types).map(&:id)
  end

  def all_additional_charge_types
    AdditionalChargeType.where(id: all_additional_charge_types_ids).order(:status, :name)
  end

  def to_liquid
    @transactable_drop ||= TransactableDrop.new(self.decorate)
  end

  def self.xml_attributes(transactable_type = nil)
    self.csv_fields(transactable_type || PlatformContext.current.instance.transactable_types.first)
      .keys.reject{|k| k =~ /for_(\d*)_(\w*)_price_cents/}.sort
  end

  def name_with_address
    [name, location.street].compact.join(" at ")
  end

  def order_attributes
    {
      currency_id: Currency.find_by_iso_code(currency).try(:id),
      company: company
    }
  end

  def last_booked_days
    last_reservation = orders.order('created_at DESC').first
    last_reservation ? ((Time.current.to_f - last_reservation.created_at.to_f) / 1.day.to_f).round : nil
  end

  def disable!
    self.enabled = false
    self.save(validate: false)
  end

  def disabled?
    !(enabled? && !payout_information_missing?)
  end

  def payout_information_missing?
    self.instance.require_payout? && !self.possible_payout?
  end

  def enable!
    self.enabled = true
    self.save(validate: false)
  end

  def approval_request_acceptance_cancelled!
    update_attribute(:enabled, false) unless is_trusted?
  end

  def approval_request_approved!
    update_attribute(:enabled, true) if is_trusted?
  end

  def approval_request_rejected!(approval_request_id)
    WorkflowStepJob.perform(WorkflowStep::ListingWorkflow::Rejected, self.id, approval_request_id)
  end

  def approval_request_questioned!(approval_request_id)
    WorkflowStepJob.perform(WorkflowStep::ListingWorkflow::Questioned, self.id, approval_request_id)
  end

  def self.csv_fields(transactable_type)
    transactable_type.action_types.map(&:pricings).flatten.inject({}) do |hash, pricing|
      hash[:"for_#{pricing.units_to_s}_price_cents"] = "for_#{pricing.units_to_s}_price_cents".humanize
      hash
    end.merge(
      name: 'Name', description: 'Description',
      external_id: 'External Id', enabled: 'Enabled',
      confirm_reservations: 'Confirm reservations', capacity: 'Capacity', quantity: 'Quantity',
      listing_categories: 'Listing categories', rental_shipping_type: "Rental shipping type",
      currency: 'Currency', minimum_booking_minutes: 'Minimum booking minutes'
    ).reverse_merge(
      transactable_type.custom_attributes.shared.pluck(:name, :label).inject({}) do |hash, arr|
        hash[arr[0].to_sym] = arr[1].presence || arr[0].humanize
        hash
      end
    )
  end

  def transactable_type_id
    read_attribute(:transactable_type_id) || transactable_type.try(:id)
  end

  def set_external_id
    self.update_column(:external_id, "manual-#{id}") if self.external_id.blank?
  end

  def reviews
    @reviews ||= Review.for_reviewables(self.orders.pluck(:id), 'Reservation')
  end

  def has_reviews?
    reviews.size > 0
  end

  def question_average_rating
    @rating_answers_rating ||= RatingAnswer.where(review_id: reviews.map(&:id))
      .group(:rating_question_id).average(:rating)
  end

  def recalculate_average_rating!
    average_rating = reviews.average(:rating) || 0.0
    self.update(average_rating: average_rating)
  end

  # TODO action rfq
  def action_rfq?
    super && self.transactable_type.action_rfq?
  end

  def express_checkout_payment?
    instance.payment_gateway(company.iso_country_code, currency).try(:express_checkout_payment?)
  end

  #TODO rental shipping
  def possible_delivery?
    rental_shipping_type.in?(['delivery', 'both'])
  end

  # TODO: to be deleted once we get rid of instance views
  def has_action?(*args)
    action_rfq?
  end

  def currency
    read_attribute(:currency).presence || transactable_type.try(:default_currency)
  end

  def translation_namespace
    transactable_type.try(:translation_namespace)
  end

  def translation_namespace_was
    transactable_type.try(:translation_namespace_was)
  end

  def required?(attribute)
    RequiredFieldChecker.new(self, attribute).required?
  end

  def zone_utc_offset
    Time.now.in_time_zone(timezone).utc_offset / 3600
  end

  def timezone
    case self.transactable_type.timezone_rule
    when 'location' then self.location.try(:time_zone)
    when 'seller' then (self.creator || self.location.try(:creator) || self.company.try(:creator) || self.location.try(:company).try(:creator)).try(:time_zone)
    when 'instance' then self.instance.time_zone
    end.presence || Time.zone.name
  end

  def timezone_info
    unless Time.zone.name == timezone
      I18n.t('activerecord.attributes.transactable.timezone_info', timezone: timezone)
    end
  end

  def get_error_messages
    msgs = []

    errors.each do |field|
      if field =~ /\.properties/
        msgs += errors.get(field)
      else
        msgs += errors.full_messages_for(field)
      end
    end
    msgs
  end

  def action_free_booking?
    action_type.is_free_booking?
  end

  def jsonapi_serializer_class_name
    'TransactableJsonSerializer'
  end

  %w(EventBooking TimeBasedBooking NoActionBooking PurchaseAction SubscriptionBooking).each do |class_name|
    define_method("#{class_name.underscore}?") { action_type.try(:type) == "Transactable::#{class_name}" }
  end

  def initialize_action_types
    transactable_type.action_types.enabled.each do |tt_action_type|
      action_types.build(
        transactable_type_action_type: tt_action_type,
        type: "Transactable::#{tt_action_type.class.name.demodulize}"
      ) unless action_types.any?{ |at| at.transactable_type_action_type == tt_action_type }
    end
    self.action_type ||= action_types.first
  end

  def self.custom_order(order)
    case order
    when /most recent/i
      order('transactables.created_at DESC')
    when /most popular/i
      #TODO check most popular sort after followers are implemented
      order('transactables.followers_count DESC')
    when /collaborators/i
      group('transactables.id').
        joins("LEFT OUTER JOIN transactable_collaborators tc ON transactables.id = tc.transactable_id AND (tc.approved_by_owner_at IS NOT NULL AND tc.approved_by_user_at IS NOT NULL AND tc.deleted_at IS NULL)").
        order('count(tc.id) DESC')
    when /featured/i
      where(featured: true, draft: nil)
    when /pending/i
      where("(SELECT tc.id from transactable_collaborators tc WHERE tc.transactable_id = transactables.id AND tc.user_id = 6520 AND ( approved_by_user_at IS NULL OR approved_by_owner_at IS NULL) AND deleted_at IS NULL LIMIT 1) IS NOT NULL")
    else
      if PlatformContext.current.instance.is_community?
        order('transactables.followers_count DESC')
      else
        all
      end
    end
  end

  def cover_photo
    photos.first || Photo.new
  end

  def build_new_collaborator
    OpenStruct.new(email: nil)
  end

  def new_collaborators
    (@new_collaborators || []).empty? ? [OpenStruct.new(email: nil)] : @new_collaborators
  end

  def new_collaborators_attributes=(attributes)
    @new_collaborators = (attributes || {}).values.map { |c| c[:email] }.reject(&:blank?).uniq.map { |email| OpenStruct.new(email: email) }
  end

  private

  def close_request_for_quotes
    self.transactable_tickets.with_state(:open).each { |ticket| ticket.resolve! }
    true
  end

  def set_possible_payout
    self.possible_payout = self.company.present? && self.company.merchant_accounts.verified.any? do |merchant_account|
      merchant_account.supports_currency?(currency) && merchant_account.payment_gateway.active_in_current_mode?
    end
    true
  end

  def set_currency
    self.currency = currency
    true
  end

  def set_activated_at
    if enabled_changed?
      self.activated_at = (enabled ? Time.current : nil)
    end
    true
  end

  def set_enabled
    self.enabled = is_trusted? if self.enabled
    true
  end

  def set_confirm_reservations
    if confirm_reservations.nil?
      self.confirm_reservations = action_type.transactable_type_action_type.confirm_reservations
    end
    true
  end

  def set_action_type
    self.action_type ||= action_types.find(&:enabled)
  end

  def decline_reservations
    orders.unconfirmed.each do |r|
      r.reject!
    end

    recurring_bookings.with_state(:unconfirmed, :confirmed, :overdued).each do |booking|
      booking.host_cancel!
    end
  end

  def document_requirement_hidden?(attributes)
    attributes.merge!(_destroy: '1') if attributes['removed'] == '1'
    attributes['hidden'] == '1'
  end

  def should_create_sitemap_node?
    draft.nil? && enabled?
  end

  def should_update_sitemap_node?
    draft.nil? && enabled?
  end

  # Counter culture does not play along well (on destroy) with acts_as_paranoid
  def fix_counter_caches
    if self.creator && !self.creator.destroyed?
      self.creator.update_column(:transactables_count, self.creator.listings.where(draft: nil).count)
    end
    true
  end

  # Counter culture does not play along well (on destroy) with acts_as_paranoid
  def fix_counter_caches_after_commit
    execute_after_commit { fix_counter_caches }
    true
  end

  def restore_photos
    self.photos.only_deleted.where('deleted_at >= ? AND deleted_at <= ?', self.deleted_at - 30.seconds, self.deleted_at + 30.seconds).each do |photo|
      begin
        photo.restore(recursive: true)
      rescue
      end
    end
  end

  def restore_links
    self.links.only_deleted.where('deleted_at >= ? AND deleted_at <= ?', self.deleted_at - 30.seconds, self.deleted_at + 30.seconds).each do |link|
      begin
        link.restore(recursive: true)
      rescue
      end
    end
  end

  def trigger_workflow_alert_for_added_collaborators
    return true if @new_collaborators.nil?
    @new_collaborators.each do |collaborator|
      collaborator_email = collaborator.email.try(:downcase)
      next if collaborator_email.blank?
      user = User.find_by(email: collaborator_email)
      next unless user.present?
      unless self.transactable_collaborators.for_user(user).exists?
        pc = self.transactable_collaborators.build(user: user, email: collaborator_email, approved_by_owner_at: Time.zone.now)
        pc.save!
        WorkflowStepJob.perform(WorkflowStep::CollaboratorWorkflow::CollaboratorAddedByTransactableOwner, pc.id)
      end
    end
  end

  def restore_transactable_collaborators
    self.transactable_collaborators.only_deleted.where('deleted_at >= ? AND deleted_at <= ?', self.deleted_at - 30.seconds, self.deleted_at + 30.seconds).each do |tc|
      begin
        tc.restore(recursive: true)
      rescue
      end
    end
  end

  class NotFound < ActiveRecord::RecordNotFound; end
end

