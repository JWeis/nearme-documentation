# frozen_string_literal: true
class DeliveryDrop < BaseDrop
  # @return [DeliveryDrop]
  attr_reader :delivery

  # @!method courier
  #   @return [String] name of the shipping courier service used
  # @!method status
  #   @return [String] status of the delivery (e.g. 'Pickup')
  # @!method order_reference
  #   @return [String] external order id
  # @!method pickup_date
  #   @return [Date] date when the delivery can be picked up
  # @!method tracking_url
  #   @return [String] url with tracking information for the delivery
  delegate :courier, :status, :order_reference, :pickup_date, :tracking_url, to: :delivery

  def initialize(delivery)
    @delivery = delivery
  end

  # @return [String] shipping label url in PDF format
  def label_url
    routes.dashboard_delivery_package_label_path(delivery, :a4)
  end

  # @return [Boolean] delivery cancellable true / false
  def cancellable?
    Deliveries::CancellationPolicy.new(delivery).allowed?
  end
end
