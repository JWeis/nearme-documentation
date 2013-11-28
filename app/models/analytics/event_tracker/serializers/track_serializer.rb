# Extracts necessary attributes from objects passed to track_charge 

class Analytics::EventTracker::Serializers::TrackSerializer

  def initialize(*objects)
    @objects = objects
  end

  def serialize
    @objects.compact.map { |o| serialize_object(o) }.inject(:merge) || {}
  end

  private 

  def serialize_object(object)
    self.class.serialize_object(object)
  end

  def self.serialize_object(object)
    case object
    when Location
      {
        location_address: object.address,
        location_currency: object.currency,
        location_suburb: object.suburb,
        location_city: object.city,
        location_state: object.state,
        location_country: object.country,
        location_postcode: object.postcode,
        location_url: Rails.application.routes.url_helpers.location_url(object)
      }
    when Listing
      {
        listing_name: object.name,
        listing_quantity: object.quantity,
        listing_confirm: object.confirm_reservations,
        listing_daily_price: object.daily_price.try(:dollars),
        listing_weekly_price: object.weekly_price.try(:dollars),
        listing_monthly_price: object.monthly_price.try(:dollars),
        listing_url: Rails.application.routes.url_helpers.listing_url(object)
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
        location_country: object.location.country,
        location_postcode: object.location.postcode
      }
    when User
      {
        first_name: object.first_name,
        last_name: object.last_name,
        email: object.email,
        phone: object.phone,
        job_title: object.job_title,
        industries: object.industries.map(&:name),
        created: object.created_at,
        location_number: object.locations.count,
        listing_number: object.listings.count,
        bookings_total: object.reservations.count,
        bookings_confirmed: object.confirmed_reservations.count,
        bookings_rejected: object.rejected_reservations.count,
        bookings_expired: object.expired_reservations.count,
        bookings_cancelled: object.cancelled_reservations.count,
        google_analytics_id: object.google_analytics_id,
        browser: object.browser,
        browser_version: object.browser_version,
        platform: object.platform,
        positive_host_ratings_count: object.host_ratings.positive.count,
        negative_host_ratings_count: object.host_ratings.negative.count,
        positive_guest_ratings_count: object.guest_ratings.positive.count,
        negative_guest_ratings_count: object.guest_ratings.negative.count
      }
    when Listing::Search::Params::Web
      {
        search_street: object.street,
        search_suburb: object.suburb,
        search_city: object.city,
        search_state: object.state,
        search_country: object.country,
        search_postcode: object.postcode
      }
    when SearchNotification
      {}
    when Hash
      object
    else
      raise "Can't serialize #{object}."
    end
  end

end

