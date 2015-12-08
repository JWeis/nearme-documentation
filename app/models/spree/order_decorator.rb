Spree::Order.class_eval do

  const_set(:PAYMENT_METHODS,
    :credit_card => 'credit_card',
    :nonce       => 'nonce',
    :manual      => 'manual',
  )

  include Spree::Scoper
  include Payable
  include Chargeable

  attr_reader :card_number, :card_code, :card_exp_month, :card_exp_year, :card_holder_first_name, :card_holder_last_name
  attr_accessor :payment_method_nonce, :start_express_checkout, :express_checkout_redirect_url

  delegate :service_fee_guest_percent, :service_fee_host_percent, to: :instance

  scope :completed, -> { where(state: 'complete') }
  scope :approved, -> { where.not(approved_at: nil) }
  scope :paid, -> { where(payment_state: 'paid') }
  scope :shipped, -> { where(shipment_state: 'shipped') }
  scope :reviewable, -> { completed.approved.paid.shipped }
  scope :cart, -> { where(state: ['cart', 'address', 'delivery', 'payment']).order('created_at ASC') }

  belongs_to :company, -> { with_deleted }
  belongs_to :instance
  belongs_to :partner
  belongs_to :platform_context_detail, polymorphic: true
  belongs_to :payment_method

  has_one :billing_authorization, -> { where(success: true) }, as: :reference
  has_many :billing_authorizations, as: :reference
  has_many :near_me_payments, as: :payable, class_name: '::Payment'
  has_many :shipping_methods, class_name: 'Spree::ShippingMethod'
  has_many :additional_charges, as: :target
  has_many :payment_documents, as: :attachable, class_name: 'Attachable::PaymentDocument', dependent: :destroy

  accepts_nested_attributes_for :additional_charges, allow_destroy: true
  accepts_nested_attributes_for :payment_documents

  after_save :purchase_shippo_rate
  after_update :prepare_payments
  before_create :store_platform_context_detail
  before_update :reject_empty_documents

  [:card_number, :card_code, :card_exp_month, :card_exp_year, :card_holder_first_name, :card_holder_last_name].each do |accessor|
    define_method("#{accessor}=") do |attribute|
      instance_variable_set("@#{accessor}", attribute.try(:to_s).try(:strip))
    end
  end

  self.per_page = 5

  # We do not need spree to verify customer email
  # hence to avoid Spree::Order email validations errors
  # email validation is removed
  _validate_callbacks.each do |callback|
    callback.raw_filter.attributes.delete(:email) if callback.raw_filter.is_a?(ActiveModel::Validations::PresenceValidator)
    callback.raw_filter.attributes.delete(:email) if callback.raw_filter.is_a?(EmailValidator)
  end

  validate :validate_credit_card, if: Proc.new {|o| o.payment? && o.credit_card_payment? }
  validates_presence_of :payment_method_id, if: Proc.new {|o| o.completed? }

  def payment_method
    PaymentMethod.find_by_id(payment_method_id)
  end

  def validate_credit_card
    errors.add(:cc, I18n.t('buy_sell_market.checkout.invalid_cc')) unless credit_card.valid?
  end

  def checkout_extra_fields(attributes = {})
    @checkout_extra_fields ||= CheckoutExtraFields.new(self.user, attributes)
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      first_name: card_holder_first_name,
      last_name: card_holder_last_name,
      number: card_number,
      month: card_exp_month.to_s,
      year: card_exp_year.to_s,
      verification_value: card_code
    )
  end

  def create_pending_payment!
    payments.create(amount: total_amount, company_id: company_id)
  end

  def create_failed_payment!
    p = payments.build(amount: total_amount, company_id: company_id)
    p.started_processing
    p.failure!
  end

  def merchant_subject
    company.paypal_express_chain_merchant_account.try(:subject)
  end

  def express_token=(token)
    write_attribute(:express_token, token)
    if !token.blank?
      details = payment_gateway.gateway(merchant_subject).details_for(token)
      self.express_payer_id = details.params["payer_id"]
    end
  end

  def express_return_url
    PlatformContext.current.decorate.build_url_for_path("/orders/#{self.number}/checkout/payment")
  end

  def express_cancel_return_url
    PlatformContext.current.decorate.build_url_for_path("/orders/#{self.number}/checkout/cancel_express_checkout")
  end

  def set_credit_card(order_params)
    # self.payment_method = PAYMENT_METHODS[:credit_card]
    self.card_exp_month = order_params[:card_exp_month].try(:to_s).try(:strip)
    self.card_exp_year = order_params[:card_exp_year].try(:to_s).try(:strip)
    self.card_number = order_params[:card_number].try(:to_s).try(:strip)
    self.card_code = order_params[:card_code].try(:to_s).try(:strip)
    self.card_holder_first_name = order_params[:card_holder_first_name].try(:to_s).try(:strip)
    self.card_holder_last_name = order_params[:card_holder_last_name].try(:to_s).try(:strip)
  end

  def payable?
    payment? || (confirm? && express_token.present?)
  end

  def is_free?
    # This takes into account the entire total including shipping, additional charge
    # types (defined from Chargeable)
    self.total_amount.zero?
  end

  def additional_charge_types
    ids = []
    ids += line_items.map { |l| l.product.additional_charge_types.pluck(:id) }
    ids += line_items.map { |l| l.product_type.additional_charge_types.pluck(:id) }
    ids += instance.additional_charge_types.pluck(:id)

    AdditionalChargeType.where(id: ids.flatten)
  end

  def shipping_amount_cents
    monetize(shipment_total).cents
  end

  def tax_amount_cents
    monetize(tax_total).cents
  end

  def subtotal_amount_cents
    monetize(self.amount).cents
  end

  def seller_iso_country_code
    line_items.first.product.company.company_address.iso_country_code
  end

  def update_payment_total
    # self.payment_total = near_me_payments.paid.includes(:refunds).inject(0) { |sum, payment| sum + payment.amount - payment.refunds.sum(:amount) }
  end

  def has_successful_payments?
    near_me_payments.paid.not_refunded.any?
  end

  def has_refunded_payments?
    near_me_payments.paid.refunded.any?
  end

  def has_any_payment?
    near_me_payments.any?
  end

  def update_order
    if self.has_any_payment?
      self.update_payment_total
    end

    if self.completed?
      self.updater.update_payment_state
      self.updater.update_shipments
      self.updater.update_shipment_state
    end

    if self.completed?
      self.persist_totals
    end
  end

  def reviewable?(current_user)
    current_user != company.creator && completed? && approved_at.present? && paid? && shipped?
  end

  def paid?
    payment_state == 'paid'
  end

  # hackish hacky hack
  def owner
    user
  end

  def owner_id
    user_id
  end

  def purchase_shippo_rate
    if self.state_changed? && self.state == 'complete'
      shippo_shipping_method = self.shipping_methods.joins(:shipping_rates).merge(Spree::ShippingRate.only_selected).readonly(false).first
      if shippo_shipping_method.present?
        ShippoPurchaseRateJob.perform(shippo_shipping_method)
      end
    end

    true
  end

  def store_platform_context_detail
    self.platform_context_detail_type = PlatformContext.current.platform_context_detail.class.to_s
    self.platform_context_detail_id = PlatformContext.current.platform_context_detail.id
  end

  def reject_empty_documents
    if self.state == "complete"
      self.payment_documents = self.payment_documents.reject { |document| document.file.blank? }
    end
  end

  # Finalizes an in progress order after checkout is complete.
  # Called after transition to complete state when payments will have been processed
  def finalize!
    # lock all adjustments (coupon promotions, etc.)
    all_adjustments.each{|a| a.close}

    # update payment and shipment(s) states, and save
    updater.update_payment_state
    shipments.each do |shipment|
      shipment.update!(self)
      shipment.finalize!
    end

    updater.update_shipment_state
    save!
    updater.run_hooks

    touch :completed_at

    WorkflowStepJob.perform(WorkflowStep::OrderWorkflow::Finalized, id)

    consider_risk
  end

  def after_cancel
    shipments.each(&:cancel!)
    near_me_payments.paid.not_refunded.each(&:refund)
    WorkflowStepJob.perform(WorkflowStep::OrderWorkflow::Cancelled, id)
    self.update!
  end

  def to_liquid
    @spree_order_drop ||= Spree::OrderDrop.new(self)
  end

  def confirm_reservations?
    false
  end

  def fees_persisted?
    payment? || completed?
  end

  # We always require payment even if free, will use the free method
  def payment_required?
    true
  end

  def update_additional_charges
    # We want to delete existing additional charges before because maybe they are out of sync with
    # the additional charge types, if the MPO has changed them during the lifespan of an order
    self.additional_charges.delete_all

    additional_charge_types.each do |act|
      self.additional_charges.find_or_create_by(additional_charge_type_id: act.id, currency: currency)
    end
  end

  private

  def prepare_payments
    if self.delivery?
      update_columns({
        service_fee_amount_guest_cents: service_fee_amount_guest_cents,
        service_fee_amount_host_cents: service_fee_amount_host_cents
      })
      update_additional_charges
    end
  end

end


