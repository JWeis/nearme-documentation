# frozen_string_literal: true
module Api
  module V4
    module User
      class OrdersController < Api::V4::User::BaseController
        skip_before_action :require_authorization
        before_action :authorize_action, only: [:update]

        def create
          prepare_order

          SubmitForm.new(form_configuration: form_configuration,
                         form: order_form,
                         params: form_params,
                         current_user: current_user).call
          respond(order_form)
        end

        def update
          SubmitForm.new(form_configuration: form_configuration,
                         form: order_form, params: form_params, current_user: current_user).tap do |submit_form|
            submit_form.add_success_observer(SubmitForm::OrderActions.new(self))
            submit_form.add_success_observer(
              SubmitForm::LegacyWorkflowStepTrigger.new(WorkflowStep::OrderWorkflow::OrderUpdated,
                                                        metadata: { state_event: state_event })
            )
          end.call
          respond(order_form)
        end

        protected

        def form_params
          params[:form].presence || {}
        end

        def prepare_order
          @order = transactable_pricing.order_class.new(
            reservation_type_id: form_params[:reservation_type_id],
            user: current_user
          )
        end

        def transactable
          @transactable ||= Transactable.find(form_params[:transactable_id])
        end

        def transactable_pricing
          @transactable_pricing ||= transactable.action_type.pricings.find(form_params[:transactable_pricing_id])
        end

        def model
          @model ||= order_form.model
        end

        def payment
          @payment ||= model.payment
        end

        def order
          @order ||= Order.find_by!('id = :id AND (user_id = :user_id OR creator_id = :user_id)',
                                    id: params[:id], user_id: current_user.id)
        end

        def authorize_action
          raise ArgumentError if !lister? && %w(confirm complete host_cancel reject).include?(state_event)
          raise ArgumentError if !enquirer? && %w(user_cancel).include?(state_event)
        end

        def state_event
          @state_event ||= order_form.try(:state_event)
        end

        def lister?
          current_user.id == order.creator_id
        end

        def enquirer?
          current_user.id == order.user_id
        end

        def reservation?
          model.is_a?(Reservation)
        end

        def order_form
          @order_form ||= form_configuration.build(order)
        end
      end
    end
  end
end
