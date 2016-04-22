class InstanceAdmin::Manage::PaymentsController < InstanceAdmin::Manage::BaseController

  skip_before_filter :check_if_locked

  def index
    params[:mode] ||= PlatformContext.current.instance.test_mode ? 'test' : 'live'

    @payment_gateways = PaymentGateway.all.sort_by(&:name)
    payments_scope = Payment.order('created_at DESC')
    payments_scope = payments_scope.where(state: params[:state]) if params[:state].present?
    payments_scope = payments_scope.where(payment_gateway_id: params[:payment_gateway_id]) if params[:payment_gateway_id].present?
    payments_scope = payments_scope.where(payment_gateway_mode: params[:mode])
    payments_scope = case params[:transferred]
      when 'awaiting', nil
        payments_scope.needs_payment_transfer
      when 'transferred'
        payments_scope.transferred
      else
        payments_scope
    end


    @payments = PaymentDecorator.decorate_collection(payments_scope.paginate(per_page: 20, :page => params[:page]))
  end

end

