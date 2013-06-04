class Analytics::EventTracker
  attr_accessor :user, :params

  def initialize(api, user, params = {}, anonymous_id)
    @api = api
    @anonymous_id = anonymous_id
    self.user = user
    self.params = params
  end

  def user=(user)
    @user = user

    if @user
      set(@user.id, @user)
    end
  end

  def params=(params)
    @params = params
    register_params = {}

    if @params[:utm_source]
      register_params.merge!({ utm_source: @params[:utm_source]})
    end

    if @params[:utm_campaign]
      register_params.merge!({ utm_campaign: @params[:utm_campaign]})
    end

    unless register_params.empty?
      register(register_params)
    end
  end

  include ListingEvents
  include LocationEvents
  include ReservationEvents
  include SpaceWizardEvents
  include UserEvents

  private

  def track_event(event_name, *objects)
    @api.track(event_name, serialize_event_properties(objects))
  end

  def charge(user_id, total_amount_dollars)
    @api.track_charge(user_id, total_amount_dollars)
  end

  def set(user_id, *objects)
    @api.set(user_id, event_properties(objects))
  end

  def identify(distinct_id)
    @api.identify(distinct_id)
  end

  def alias_user(distinct_id, previous_distinct_id)
    @api.alias_user(distinct_id, previous_distinct_id)
  end

  def register(properties)
    @api.register(properties)
  end

  def serialize_event_properties(objects)
    begin
      event_properties(objects).merge!(global_event_properties)
    rescue
      {}
    end
  end

  def event_properties(objects)
    objects.map { |o| serialize_object(o)
    }.inject(:merge)
  end

  def global_event_properties
    hash = {}

    distinct_id = unless @user.nil?
      @user.id
    else
      @anonymous_id
    end

    hash.merge!({ distinct_id: distinct_id })

    hash
  end

  def serialize_object(object)
    case object
    when Location
      {
        location_address: object.address,
        location_currency: object.currency,
        location_suburb: object.suburb,
        location_city: object.city,
        location_state: object.state,
        location_country: object.country
      }
    when Listing
      {
        listing_name: object.name,
        listing_quantity: object.quantity,
        listing_confirm: object.confirm_reservations,
        listing_daily_price: object.daily_price.try(:dollars),
        listing_weekly_price: object.weekly_price.try(:dollars),
        listing_monthly_price: object.monthly_price.try(:dollars)
      }
    when Reservation
      {
        booking_desks: object.quantity,
        booking_days: object.total_days,
        booking_total: object.total_amount_dollars,
        location_address: object.location.address,
        location_currency: object.location.currency,
        location_suburb: object.location.suburb,
        location_city: object.location.city,
        location_state: object.location.state,
        location_country: object.location.country
      }
    when User
      {
        name: object.name,
        email: object.email,
        phone: object.phone,
        job_title: object.job_title
      }
    when Listing::Search::Params::Web
      {
        search_suburb: object.suburb,
        search_city: object.city,
        search_state: object.state,
        search_country: object.country
      }
    when Hash
      object
    else
      raise "Can't serialize #{object}."
    end
  end

end

