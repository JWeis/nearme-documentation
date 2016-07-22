class ExpressCheckoutController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_payment

  def return
    @payment.express_payer_id = params[:PayerID]
    reservation = @payment.payable
    if @payment.authorize && reservation.reload.save
      event_tracker.updated_profile_information(reservation.owner)
      event_tracker.updated_profile_information(reservation.host)
      event_tracker.requested_a_booking(reservation)

      redirect_to dashboard_orders_path
    else
      redirect_to order_checkout_path(@order)
    end
  end

  def cancel
    flash[:error] = t('flash_messages.reservations.payment_failed')
    @order = @payment.payable
    @order.restart_checkout!
    @payment.destroy

    redirect_to order_checkout_path(@order)
  end

  private

  def find_payment
    @order = current_user.orders.find(params[:order_id])
    @payment = Payment.where(payable_id: @order.id, payable_type: @order.class.name).find_by_express_token!(params[:token])
  end
end