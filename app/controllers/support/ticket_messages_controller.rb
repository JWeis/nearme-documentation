class Support::TicketMessagesController < Support::BaseController
  def create
    message = Support::TicketMessage.new(message_params)
    message.user = current_user
    message.ticket = ticket
    if message.valid?
      message.save!
      if Transactable === ticket.target
        SupportMailer.enqueue.rfq_request_updated(@ticket, message)
        SupportMailer.enqueue.rfq_support_updated(@ticket, message)
      else
        SupportMailer.enqueue.request_updated(@ticket, message)
        SupportMailer.enqueue.support_updated(@ticket, message)
      end
      flash[:success] = t('flash_messages.support.ticket_message.created')
    else
      flash[:error] = t('flash_messages.support.ticket_message.error') unless close?
    end

    if close?
      if ticket.resolve
        flash[:success] = t('flash_messages.support.ticket_message.closed')
      else
        flash[:error] = t('flash_messages.support.ticket_message.error')
      end
    end

    redirect_to support_ticket_path(ticket)
  end

  private

  def ticket
    @ticket ||= current_user.tickets.find(params[:ticket_id])
  end

  def close?
    params[:commit] == "Close Ticket"
  end

  def message_params
    params.fetch(:support_ticket_message, {}).permit(:message)
  end
end
