class WorkflowStep::RecurringBookingWorkflow::BaseStep < WorkflowStep::BaseStep
  def self.belongs_to_transactable_type?
    true
  end

  def initialize(recurring_booking_id)
    @recurring_booking = RecurringBooking.find_by_id(recurring_booking_id)
    @lister = @recurring_booking.host
    @enquirer = @recurring_booking.owner
  end

  def workflow_type
    'recurring_booking'
  end

  # recurring_booking:
  #   RecurringBooking object
  # reservation:
  #   Reservation object
  # user:
  #   listing User object
  # host:
  #   enquiring User object
  # listing:
  #   Transactable object
  def data
    {
      recurring_booking: @recurring_booking,
      enquirer: enquirer,
      lister: lister,
      reservation: @recurring_booking,
      listing: @recurring_booking.transactable
    }
  end

  def transactable_type_id
    @recurring_booking.transactable.transactable_type_id
  end
end