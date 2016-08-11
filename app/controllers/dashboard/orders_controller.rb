class Dashboard::OrdersController < Dashboard::BaseController
  before_action :find_order, except: [:index, :new]
  before_action :find_transactable, only: :new
  before_action :redirect_to_index_if_not_editable, only: [:edit, :update]

  def index
    @rating_systems = reviews_service.get_rating_systems
    @order_search_service = OrderSearchService.new(order_scope, params)
  end

  def enquirer_cancel
    if @order.enquirer_cancelable?
      if @order.user_cancel
        # we want to make generic workflows probably. Maybe even per TT [ many to many ]
        WorkflowStepJob.perform("WorkflowStep::#{@order.object.class.name}Workflow::EnquirerCancelled".constantize, @order.id)
        event_tracker.cancelled_a_booking(@order, { actor: 'guest' })
        event_tracker.updated_profile_information(@order.owner)
        event_tracker.updated_profile_information(@order.host)
        flash[:success] = t('flash_messages.reservations.reservation_cancelled')
      else
        flash[:error] = t('flash_messages.reservations.reservation_not_confirmed')
      end
    else
      flash[:error] = t('flash_messages.reservations.reservation_not_cancellable')
    end
    redirect_to request.referer.presence || dashboard_orders_path
  end

  def show
  end

  def new
    @order = @transactable_pricing.order_class.new(user: current_user)
    @order.add_line_item!(params)
    build_payment_documents
    @update_path = dashboard_order_path(@order)
    render template: 'checkout/show'
  end

  def edit
    @update_path = dashboard_order_path(@order)
    render template: 'checkout/show'
  end

  def update
    @order.checkout_update = true
    if @order.update_attributes(order_params)
      if @order.payment && @order.payment.express_checkout_payment? && @order.payment.express_checkout_redirect_url
        redirect_to @order.payment.express_checkout_redirect_url
        return
      end

      flash[:notice] = ""  unless @order.inactive?
      flash[:error] = @order.errors.full_messages.join(',<br />')
      event_tracker.updated_profile_information(@order.owner)
      event_tracker.updated_profile_information(@order.host)
      event_tracker.requested_a_booking(@order)

      card_message = @order.payment.credit_card_payment? ? t('flash_messages.reservations.credit_card_will_be_charged') : ''
      flash[:notice] = t('flash_messages.reservations.reservation_made', message: card_message)
      redirect_to dashboard_company_transactable_type_transactables_path(@order.transactable.transactable_type)
    else
      @update_path = dashboard_order_path(@order)
      render template: 'checkout/show'
      flash[:error] = @order.errors.full_messages.join(',<br />')
    end
  end

  def success
    render action: :show
  end

  private

  def find_transactable
    if @transactable = current_user.approved_transactables_collaborated.find_by(id: params[:transactable_id])
      params[:transactable_pricing_id] ||= @transactable.action_type.pricings.first.id
      @transactable_pricing = @transactable.action_type.pricings.find(params[:transactable_pricing_id])
    else
      flash[:error] = I18n.t('dashboard.orders.not_collaborator')
      redirect_to dashboard_company_transactable_type_transactables_path(TransactableType.first)
    end
  end

  def build_payment_documents
    @order.transactables.each do |transactable|
      if transactable.document_requirements.blank? &&
        PlatformContext.current.instance.force_file_upload?
        transactable.document_requirements.create({
          label: I18n.t("upload_documents.file.default.label"),
          description: I18n.t("upload_documents.file.default.description")
        })
      end

      requirement_ids = @order.payment_documents.map do |pd|
        pd.payment_document_info.document_requirement_id
      end

      if transactable.upload_obligation.blank? &&
        PlatformContext.current.instance.documents_upload_enabled?
        transactable.create_upload_obligation(level: UploadObligation.default_level)
      end

      transactable.document_requirements.each do |req|
        if !req.item.upload_obligation.not_required? && !requirement_ids.include?(req.id)
          @order.payment_documents.build(
            attachable: @order,
            user: @user,
            payment_document_info_attributes: {
              document_requirement: req
            }
          )
        end
      end
    end
  end

  def order_scope
    @order_scope ||= current_user.orders.active
  end

  def find_order
    @order = current_user.orders.find(params[:id]).decorate
  end

  def reviews_service
    @reviews_service ||= ReviewsService.new(current_user, params)
  end

  def redirect_to_index_if_not_editable
    redirect_to request.referer.presence || dashboard_orders_path unless @order.enquirer_editable?
  end

  def order_params
    params.require(:order).permit(secured_params.order(@order.transactable.transactable_type.reservation_type))
  end

end
