class Billing::Gateway::BaseProcessor

  attr_accessor :user

  def initialize(instance, currency)
    @instance = instance
    @currency = currency
  end

  def ingoing_payment(user)
    @user = user
    @client = @user
    self
  end

  def outgoing_payment(sender, receiver)
    @sender = sender
    @receiver = receiver
    @client = receiver
    self
  end

  def self.instance_supported?(instance)
    raise NotImplementedError
  end

  def self.currency_supported?(instance)
    raise NotImplementedError
  end

  def self.processor_supported?(instance)
    raise NotImplementedError
  end

  # Make a charge against the user
  #
  # charge_details - Hash of details describing the charge
  #                  :amount - The amount in cents to charge
  #                  :reference - A reference record to assign to the charge
  #
  # Returns the Charge attempt record.
  # Test the status of the charge with the Charge#success? predicate
  def charge(charge_details)
    amount, reference = charge_details[:amount], charge_details[:reference]
    @charge = Charge.create(
      amount: amount,
      currency: @currency,
      user_id: user.id,
      reference: reference
    )
    # Use concrete processor to perform real-life charge attempt. Processor will trigger charge_failed or charge_successful callbacks.
    process_charge(@charge.amount)
    @charge
  end

  def payout(payout_details)
    amount, reference = payout_details[:amount], payout_details[:reference]
    raise "Unexpected state, amounts currency is different from the one that initialized processor" if amount.currency.iso_code != @currency
    @payout = Payout.create(
      amount: amount.cents,
      currency: amount.currency.iso_code,
      reference: reference
    )
    process_payout(amount)
    @payout
  end

  # Contains implementation for storing credit card by third party
  def store_credit_card(credit_card)
    raise NotImplementedError
  end

  # Contains implementation for processing credit card by third party
  def process_charge
    raise NotImplementedError
  end

  # Contains implementation for transferring money to company
  def process_payout
    raise NotImplementedError
  end

  protected

  # Callback invoked by processor when charge was successful
  def charge_successful(response)
    @charge.charge_successful(response)
  end

  # Callback invoked by processor when charge failed
  def charge_failed(response)
    @charge.charge_failed(response)
  end

  # Callback invoked by processor when payout was successful
  def payout_successful(response)
    @payout.payout_successful(response)
  end

  # Callback invoked by processor when payout failed
  def payout_failed(response)
    @payout.payout_failed(response)
  end

  def self.instance_client(client, instance)
    client.instance_clients.where(:instance_id => instance.id).first.presence || client.instance_clients.create(:instance_id => instance.id)
  end

  def instance_client
    @instance_client ||= self.class.instance_client(@client, @instance)
  end

end
