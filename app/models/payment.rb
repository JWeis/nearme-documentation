class Payment < ActiveRecord::Base
  has_paper_trail
  acts_as_paranoid
  auto_set_platform_context
  scoped_to_platform_context
  inherits_columns_from_association([:company_id], :payable)

  attr_accessor :payment_response_params

  # === Associations

  # Payable association connects Payment with Reservation and Spree::Order
  belongs_to :company
  belongs_to :instance
  belongs_to :payable, polymorphic: true
  has_many :charges, dependent: :destroy
  has_many :refunds

  # === Scopes
  # These payments have been attempted but failed during the charge attempt.
  # We can inspect the charges to see what the failure reason was
  # from the gateway response.
  scope :needs_payment_capture, -> {
    where(paid_at: nil).where("#{table_name}.failed_at IS NOT NULL")
  }

  scope :paid, -> {
    where("#{table_name}.paid_at IS NOT NULL")
  }

  scope :last_x_days, lambda { |days_in_past|
    where('DATE(payments.created_at) >= ? ', days_in_past.days.ago)
  }

  scope :needs_payment_transfer, -> {
    paid.where(payment_transfer_id: nil)
  }

  scope :total_by_currency, -> {
    paid.group('payments.currency').
    select('
        payments.currency,
        SUM(
          payments.subtotal_amount_cents
          + payments.service_fee_amount_guest_cents
        )
           ')
  }

  # === Callbacks
  before_validation :assign_currency
  after_create :capture

  validates :currency, presence: true

  # === Helpers
  monetize :subtotal_amount_cents
  monetize :service_fee_amount_guest_cents
  monetize :service_fee_amount_host_cents
  monetize :total_amount_cents

  def total_amount_cents
    subtotal_amount_cents + service_fee_amount_guest_cents
  end

  def subtotal_amount_cents_after_refund
    result = nil

    if self.payable.respond_to?(:cancelled_by_host?) && self.payable.cancelled_by_host?
      result = 0
    else
      result = subtotal_amount_cents - refunds.successful.sum(&:amount)
    end

    result
  end

  def final_service_fee_amount_host_cents
    result = self.service_fee_amount_host_cents

    if (self.payable.respond_to?(:cancelled_by_host?) && self.payable.cancelled_by_host?) || (self.payable.respond_to?(:cancelled_by_guest?) && self.payable.cancelled_by_guest?)
      result = 0
    end

    result
  end

  def final_service_fee_amount_guest_cents
    result = self.service_fee_amount_guest_cents

    if self.payable.respond_to?(:cancelled_by_host?) && self.payable.cancelled_by_host?
      result = 0
    end

    result
  end

  def amount
    total_amount
  end

  # Attempt to capture the payment through the billing gateway
  def capture
    return if paid?

    # Generates a ChargeAttempt with this record as the payable.

    if payable.billing_authorization.nil? && !payable.remote_payment?
      response = billing_gateway.authorize(payable.total_amount_cents, payable.credit_card.token, { customer: payable.credit_card.instance_client.customer_id, order_id: payable.id })
      if response[:error].present?
        raise Billing::Gateway::PaymentAttemptError, "Failed authorization of credit card token of InstanceClient(id=#{payable.owner.instance_clients.first.try(:id)}) - #{response[:error]}"
      else
        payable.create_billing_authorization(
          token: response[:token],
          payment_gateway_class: billing_gateway.class.name,
          payment_gateway_mode: PlatformContext.current.instance.test_mode? ? "test" : "live"
        )
      end
    end

    begin
      billing_gateway.charge(total_amount_cents, self, payable.billing_authorization.try(:token))
      touch(:paid_at)

      if payable.respond_to?(:date)
        ReservationChargeTrackerJob.perform_later(payable.date.end_of_day, payable.id)
      end
    rescue => e
      # Needs to be retried at a later time...
      touch(:failed_at)
      update_column(:recurring_booking_error, e)
    end

  end

  def refund
    return if !paid?
    return if refunded?
    return if amount_to_be_refunded <= 0

    successful_charge = charges.successful.first
    return if successful_charge.nil?

    refund = billing_gateway.refund(amount_to_be_refunded, self, successful_charge)

    if refund.success?
      touch(:refunded_at)
      true
    else
      false
    end
  end

  def amount_to_be_refunded
    if payable.respond_to?(:cancelled_by_guest?) && payable.cancelled_by_guest?
      (subtotal_amount_cents * (1 - self.cancellation_policy_penalty_percentage.to_f/100.0)).to_i
    else
      total_amount_cents
    end
  end

  def refunded?
    refunded_at.present?
  end

  def paid?
    paid_at.present?
  end

  private

  def billing_gateway
    @billing_gateway ||= if payable.billing_authorization.try(:payment_gateway_class).present?
                           payable.billing_authorization.payment_gateway_class.to_s.constantize.new(payable.owner, instance, currency)
                         else
                           Billing::Gateway::Incoming.new(payable.owner, instance, currency, payable.company.iso_country_code)
                         end
  end

  def assign_currency
    self.currency ||= payable.currency
  end

end
