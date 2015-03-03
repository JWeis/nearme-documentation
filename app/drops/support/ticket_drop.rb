class Support::TicketDrop < BaseDrop
  attr_reader :ticket

  def initialize(ticket)
    @ticket = ticket
  end

  def first_message
    ticket.first_message
  end

  def created_at
    ticket.created_at.to_s
  end

  def url
    routes.support_ticket_path(ticket)
  end

  def rfq
    if ticket.target.action_free_booking?
      'request'
    else
      'offer'
    end
  end

  def messages_count
    messages.count
  end

  def admin_url
    case ticket.target
    when Transactable, Spree::Product
      routes.dashboard_support_ticket_path(ticket)
    when Instance
      routes.instance_admin_manage_support_ticket_path(ticket)
    else
      raise NotImplementedError.new("Unknown ticket target: #{ticket.target.class}")
    end
  end

  def id
    ticket.id
  end

  def messages
    ticket.messages.tap(&:shift)
  end
end
