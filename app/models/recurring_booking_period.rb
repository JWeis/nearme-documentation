class RecurringBookingPeriod < ActiveRecord::Base

  include Chargeable

  has_paper_trail
  acts_as_paranoid
  auto_set_platform_context
  scoped_to_platform_context

  has_many :additional_charges, as: :target
  has_many :billing_authorizations, as: :reference
  has_many :payments, as: :payable, dependent: :destroy
  has_one :billing_authorization, -> { where(success: true) }, as: :reference

  belongs_to :recurring_booking
  belongs_to :credit_card

  delegate :payment_gateway, :company, :company_id, :user, :owner, :currency,
    :service_fee_guest_percent, :service_fee_host_percent, to: :recurring_booking

  def generate_payment!
    payment = payments.build(
      company: company,
      service_fee_amount_guest_cents: service_fee_amount_guest_cents,
      service_fee_amount_host_cents: service_fee_amount_host_cents,
      subtotal_amount_cents: subtotal_amount_cents,
      customer: credit_card.instance_client.customer_id,
      payment_method: payment_method,
      currency: currency
    )

    payment.authorize && payment.save! && payment.capture!

    if payment.paid?
      self.paid_at = Time.zone.now
      # if we end up doing something in wrong order, we want to have the maximum period_end_date which was paid.
      # so if we pay for December, November and October, we want paid_until to be 31st of December
      recurring_booking.update_attribute(:paid_until, period_end_date) unless recurring_booking.paid_until.present? && recurring_booking.paid_until > period_end_date
    else
      recurring_booking.overdue
    end
    save!
    payment
  end

  def payment_method
    # TODO we should assign payment method to recurring booking as in normal payment
    payment_gateway.payment_methods.where(payment_method_type: 'credit_card').first
  end

  def fees_persisted?
    persisted?
  end

  def tax_amount_cents
    0
  end

  def shipping_amount_cents
    0
  end
end

