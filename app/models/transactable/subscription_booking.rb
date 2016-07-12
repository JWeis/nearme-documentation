class Transactable::SubscriptionBooking < Transactable::ActionType

  validates :pricings, presence: true, if: :enabled?
  validates_associated :pricings, if: :enabled?

  def booking_module_options
    super.merge({
      minimum_date: Time.now.in_time_zone(timezone).to_date,
      maximum_date: Time.now.in_time_zone(timezone).advance(years: 1).to_date,
      pricings: Hash[pricings.map{|pricing| [pricing.id, {price: pricing.price.cents }] }]
    })
  end

end