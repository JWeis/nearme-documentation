# frozen_string_literal: true
class ReservationPeriodForm < BaseForm
  include Reform::Form::ActiveModel::ModelReflections

  validates :date, presence: true

  class << self
    def decorate(configuration)
      Class.new(self) do
        %i(start_minute end_minute hours).each do |field|
          add_property(field, configuration[field])
          add_validation(field, configuration[field])
        end
        validate :validate_minimum_booking_minutes if configuration.delete(:validate_minimum_booking_minutes)
        validate :validate_minimum_booking_hours if configuration.delete(:validate_minimum_booking_hours)
        inject_dynamic_fields(configuration)

        def hours=(hours)
          super(hours.to_f)
        end

        def end_minute
          start_minute.to_i + hours.to_f * 60
        end
      end
    end
  end

  property :_destroy, virtual: true

  # @!attribute date
  #   @return [Date] actual date for this reservation period
  property :date

  # FIXME: find better way? :|
  def validate_minimum_booking_minutes
    errors.add(:end_minute, "must be at least #{model.reservation.minimum_booking_minutes} minutes") if start_minute.to_i + model.reservation.minimum_booking_minutes > end_minute.to_i
  end

  def validate_minimum_booking_hours
    errors.add(:hours, "must be at least #{model.reservation.minimum_booking_minutes.to_f / 60} hours") if start_minute.to_i + model.reservation.minimum_booking_minutes > end_minute.to_i
  end
end
