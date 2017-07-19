class AddBookingTypeToTransactables < ActiveRecord::Migration
  class TransactableType < ActiveRecord::Base
    BOOKING_TYPES = %i(regular schedule overnight).freeze
    has_many :transactables, inverse_of: :transactable_type, dependent: :destroy
  end

  def change
    add_column :transactables, :booking_type, :string, default: 'regular'

    TransactableType.find_each do |transactable_type|
      booking_type = if transactable_type.action_schedule_booking?
          'schedule'
        elsif transactable_type.action_overnight_booking?
          'overnight'
        elsif transactable_type.action_recurring_booking?
          'recurring'
        else
          'regular'
        end
      transactable_type.transactables.update_all(booking_type: booking_type)
    end
  end
end