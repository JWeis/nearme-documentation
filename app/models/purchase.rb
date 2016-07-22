class Purchase < Order

  state_machine :state, initial: :inactive do
    after_transition confirmed: [:cancelled_by_guest, :cancelled_by_host], do: [:return_transactable_quantity!]
    # after_transition confirmed: :completed, do: [:set_archived_at!]

    # event :complete do transition :confirmed => :completed; end
    event :ship do transition :completed => :shipped; end
  end

  def add_line_item!(attrs)
    transactable = Transactable.find(attrs[:transactable_id])
    transactable_pricing = transactable.action_type.pricings.find(attrs[:transactable_pricing_id])

    self.company = transactable.company
    self.creator = transactable.creator
    self.reservation_type = transactable.transactable_type.reservation_type
    self.currency = transactable.try(:currency)
    self.additional_charge_ids = attrs[:additional_charge_ids]

    transactable_line_items.build(
      name: transactable.name,
      transactable_pricing: transactable_pricing,
      quantity: attrs[:quantity],
      line_item_source: transactable,
      unit_price: transactable_pricing.price,
      line_itemable: self,
      service_fee_guest_percent: transactable_pricing.action.service_fee_guest_percent,
      service_fee_host_percent: transactable_pricing.action.service_fee_host_percent,
    )

    self.skip_checkout_validation = true
    self.save
  end

  def charge_and_confirm!
    self.errors.clear
    self.transactable_line_items.each { |t| t.validate_transactable_quantity(self) }

    if self.errors.empty? && self.valid?
      if self.unconfirmed? && (self.paid? || self.payment.capture!)
          self.create_shipments!
          self.confirm!
          self.transactable_line_items.each(&:reduce_transactable_quantity!)
          # We need to touch transactable so it's reindexed by ElasticSearch
      else
        false
      end
    end
  end

  def return_transactable_quantity!
    self.transactable_line_items.each(&:return_transactable_quantity!)
  end


  def with_payment?
    true
  end

  def with_payment_subscription?
    false
  end

  def activate_order!
  end

  def transactable
    transactables.first
  end

  def to_liquid
    @reservation_drop ||= OrderDrop.new(self)
  end

  # TODO we could want to extend that
  def can_approve_or_decline_checkout?
    true
  end

  def has_to_update_credit_card?
    false
  end

  def archived?
    archived_at.present?
  end

  def cancelable?
    true
  end

  def penalty_charge_apply?
    false
  end

  def remote_payment?
    false
  end
end