class ReservationRequest < Form

  attr_accessor :dates, :start_minute, :end_minute, :book_it_out, :exclusive_price, :guest_notes,
    :card_number, :card_exp_month, :card_exp_year, :card_code, :card_holder_first_name,
    :card_holder_last_name, :payment_method_nonce, :waiver_agreement_templates, :documents,
    :payment_method, :checkout_extra_fields, :express_checkout_redirect_url, :mobile_number
  attr_reader   :reservation, :listing, :location, :user, :client_token, :payment_method_nonce

  def_delegators :@listing,     :confirm_reservations?, :location, :billing_authorizations, :company
  def_delegators :@user,        :country_name, :country_name=, :country
  def_delegators :@reservation, :guest_notes, :quantity, :quantity=, :action_hourly_booking?, :reservation_type=,
    :credit_card_payment?, :manual_payment?, :remote_payment?, :nonce_payment?, :currency,
    :service_fee_amount_host_cents, :total_amount_cents, :create_billing_authorization,
    :express_token, :express_token=, :express_payer_id, :service_fee_guest_without_charges,
    :additional_charges, :shipping_costs_cents, :service_fee_amount_guest_cents, :merchant_subject

  before_validation :build_documents, :if => lambda { reservation.present? && documents.present? }

  validates :listing,     :presence => true
  validates :reservation, :presence => true
  validates :user,        :presence => true

  validate :validate_acceptance_of_waiver_agreements
  validate :validate_credit_card, if: lambda { reservation.present? && reservation.credit_card_payment? }
  validate :validate_empty_files, if: lambda { reservation.present? }

  def initialize(listing, user, platform_context, attributes = {}, checkout_extra_fields = {})
    @listing = listing
    @waiver_agreement_templates = []
    @checkout_extra_fields = CheckoutExtraFields.new(user, checkout_extra_fields)
    @user = @checkout_extra_fields.user
    if @listing
      @reservation = @listing.reservations.build
      @instance = platform_context.instance
      @reservation.currency = @listing.currency
      @reservation.guest_notes = attributes[:guest_notes]
      @reservation.book_it_out_discount = @listing.book_it_out_discount if attributes[:book_it_out] == 'true'
      if attributes[:exclusive_price] == 'true'
        @reservation.exclusive_price_cents = @listing.exclusive_price_cents
        attributes[:quantity] = @listing.quantity # ignore user's input, exclusive is exclusive - full quantity
      end
      @billing_gateway = @instance.payment_gateway(@listing.company.iso_country_code, @reservation.currency)
      @client_token = @billing_gateway.try(:client_token)
      @reservation.user = user
      @reservation.additional_charges << get_additional_charges(attributes)
      @reservation = @reservation.decorate
    end

    store_attributes(attributes)

    @reservation.try(:payment_method=, (payment_method.present? && payment_methods.include?(payment_method.to_s)) ? payment_method : payment_methods.first)
    self.payment_method = @reservation.try(:payment_method)

    if @user
      @user.phone ||= @user.mobile_number
      @card_holder_first_name ||= @user.first_name
      @card_holder_last_name ||= @user.last_name
    end

    if @listing
      if @reservation.action_hourly_booking? || @listing.schedule_booking?
        @start_minute = start_minute.try(:to_i)
        @end_minute = end_minute.try(:to_i)
      else
        @start_minute = nil
        @end_minute   = nil
      end

      if listing.schedule_booking?
        if @dates.is_a?(String)
          @start_minute = @dates.to_datetime.try(:min).to_i + (60 * @dates.to_datetime.try(:hour).to_i)
          @end_minute = @start_minute
          @dates = [@dates.try(:to_datetime).try(:to_date).try(:to_s)]
        end
      else
        @dates = @dates.split(',') if @dates.is_a?(String)
      end
      @dates.reject(&:blank?).each do |date_string|
        @reservation.add_period(Date.parse(date_string), start_minute, end_minute)
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      first_name: card_holder_first_name.to_s,
      last_name: card_holder_last_name.to_s,
      number: card_number.to_s,
      month: card_exp_month.to_s,
      year: card_exp_year.to_s,
      verification_value: card_code.to_s
    )
  end

  def process
    @checkout_extra_fields.assign_attributes! if @checkout_extra_fields.are_fields_present?
    @checkout_extra_fields.valid?
    @checkout_extra_fields.errors.full_messages.each { |m| add_error(m, :base) }
    clear_errors(:cc)
    # This is temporal solution that should be removed when we support multiple payment gateways for one country
    @billing_gateway = PaymentGateway::ManualPaymentGateway.new if (manual_payment? && possible_manual_payment?) || is_free?
    @checkout_extra_fields.valid? && valid? && @billing_gateway.authorize(self) && save_reservation
  end

  def reservation_periods
    reservation.periods
  end

  def payment_methods
    @payment_methods = []
    if is_free?
      @payment_methods << Reservation::PAYMENT_METHODS[:free]
    else
      @payment_methods << Reservation::PAYMENT_METHODS[:remote] if possible_remote_payment?
      @payment_methods << Reservation::PAYMENT_METHODS[:express_checkout] if possible_express_payment?
      @payment_methods << Reservation::PAYMENT_METHODS[:nonce] if possible_nonce_payment?
      @payment_methods << Reservation::PAYMENT_METHODS[:credit_card] if possible_credit_card_payment?
      @payment_methods << Reservation::PAYMENT_METHODS[:manual] if possible_manual_payment?
    end
    @payment_methods
  end

  def is_free?
    @listing.try(:action_free_booking?) && @reservation.try(:additional_charges).try(:count).try(:zero?)
  end

  def possible_credit_card_payment?
    @billing_gateway.present? && @billing_gateway.credit_card_payment? && !possible_remote_payment? && !is_free?
  end

  def possible_manual_payment?
    @reservation.try(:possible_manual_payment?) || !(possible_credit_card_payment? || possible_remote_payment? || possible_nonce_payment? || possible_express_payment?)
  end

  def possible_remote_payment?
    @billing_gateway.try(:remote?) && !is_free?
  end

  def possible_express_payment?
    @billing_gateway.try(:express_checkout?)
  end

  def possible_nonce_payment?
    @billing_gateway.try(:nonce_payment?) && !is_free?
  end

  # We don't process taxes for reservations
  def tax_total_cents
    0
  end

  def line_items
    [@reservation]
  end

  def total_amount_cents_without_shipping
    total_amount_cents
  end

  private

  def get_additional_charges(attributes)
    additional_charge_ids = AdditionalChargeType.get_mandatory_and_optional_charges(attributes.delete(:additional_charge_ids)).pluck(:id)
    additional_charges = additional_charge_ids.map { |id|
      AdditionalCharge.new(
        additional_charge_type_id: id,
        currency: currency
      )
    }
    additional_charges
  end

  def payment_method_nonce=(token)
    return false if token.blank?
    @payment_method_nonce = token
    @reservation.payment_method = payment_method
  end

  def user_has_mobile_phone_and_country?
    user && user.country_name.present? && user.mobile_number.present?
  end

  def save_reservation
    remove_empty_optional_documents
    User.transaction do
      checkout_extra_fields.save! if checkout_extra_fields.are_fields_present?

      if active_merchant_payment?
        if reservation.listing.transactable_type.cancellation_policy_enabled.present?
          reservation.cancellation_policy_hours_for_cancellation = reservation.listing.transactable_type.cancellation_policy_hours_for_cancellation
          reservation.cancellation_policy_penalty_percentage = reservation.listing.transactable_type.cancellation_policy_penalty_percentage
        end
      end
      reservation.save!
    end
  rescue ActiveRecord::RecordInvalid => error
    add_errors(error.record.errors.full_messages)
    false
  end

  def build_documents
    documents.each do |document|
      document_requirement_id = document.try(:fetch, 'payment_document_info_attributes').try(:fetch, 'document_requirement_id')
      document_requirement = DocumentRequirement.find_by(id: document_requirement_id)
      upload_obligation = document_requirement.try(:item).try(:upload_obligation)
      if upload_obligation && !upload_obligation.not_required?
        build_or_attach_document document
      else
        build_document(document)
      end
    end
  end

  def build_or_attach_document(document_params)
    attachable = Attachable::AttachableService.new(Attachable::PaymentDocument, document_params)
    if attachable.valid? && document = attachable.get_attachable
      reservation.payment_documents << document
    else
      reservation.payment_documents.build(document_params)
    end
  end

  def build_document document_params
    if reservation.listing.document_requirements.blank? &&
        PlatformContext.current.instance.documents_upload_enabled? &&
        !PlatformContext.current.instance.documents_upload.is_vendor_decides?

      document_params.delete :payment_document_info_attributes
      document_params[:user_id] = @user.id
      document = reservation.payment_documents.build(document_params)
      document_requirement = reservation.listing.document_requirements.build({
        label: I18n.t("upload_documents.file.default.label"),
        description: I18n.t("upload_documents.file.default.description"),
        item: reservation.listing
      })

      reservation.listing.build_upload_obligation(level: UploadObligation.default_level)

      document.build_payment_document_info(
        document_requirement: document_requirement,
        payment_document: document
      )

      reservation.listing.upload_obligation.save
    end
  end

  def remove_empty_optional_documents
    if reservation.payment_documents.present?
      reservation.payment_documents.each do |document|
        if document.file.blank? && document.payment_document_info.document_requirement.item.upload_obligation.optional?
          reservation.payment_documents.delete(document)
        end
      end
    end
  end

  def active_merchant_payment?
    reservation.credit_card_payment? || reservation.nonce_payment?
  end

  def validate_acceptance_of_waiver_agreements
    return if @reservation.nil?
    @reservation.assigned_waiver_agreement_templates.each do |wat|
      wat_id = wat.id
      self.send(:add_error, I18n.t('errors.messages.accepted'), "waiver_agreement_template_#{wat_id}") unless @waiver_agreement_templates.include?("#{wat_id}")
    end
  end

  def validate_credit_card
    errors.add(:cc, I18n.t('buy_sell_market.checkout.invalid_cc')) unless credit_card.valid?
  end

  def validate_empty_files
    reservation.payment_documents.each do |document|
      unless document.valid?
        self.errors.add(:base, "file_cannot_be_empty".to_sym) unless self.errors[:base].include?(I18n.t("activemodel.errors.models.reservation_request.attributes.base.file_cannot_be_empty"))
      end
    end
  end

  def validate_user
    errors.add(:user) if @user.blank? || !@user.valid?
  end

end
