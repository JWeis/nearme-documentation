class ReservationMailerPreview < MailView

  def notify_guest_of_cancellation_by_host
    ::ReservationMailer.notify_guest_of_cancellation_by_host(reservation)
  end

  def notify_guest_of_cancellation_by_guest
    ::ReservationMailer.notify_guest_of_cancellation_by_guest(reservation)
  end

  def notify_guest_of_confirmation
    ::ReservationMailer.notify_guest_of_confirmation(reservation)
  end

  def notify_guest_of_expiration
    ::ReservationMailer.notify_guest_of_expiration(reservation)
  end

  def notify_guest_of_rejection
    ::ReservationMailer.notify_guest_of_rejection(reservation)
  end

  def notify_guest_with_confirmation
    ::ReservationMailer.notify_guest_with_confirmation(reservation)
  end

  def notify_host_of_cancellation_by_guest
    ::ReservationMailer.notify_host_of_cancellation_by_guest(reservation)
  end

  def notify_host_of_cancellation_by_host
    ::ReservationMailer.notify_host_of_cancellation_by_host(reservation)
  end

  def notify_host_of_confirmation
    ::ReservationMailer.notify_host_of_confirmation(reservation)
  end

  def notify_host_of_rejection
    ::ReservationMailer.notify_host_of_rejection(reservation)
  end

  def notify_host_of_expiration
    ::ReservationMailer.notify_host_of_expiration(reservation)
  end

  def notify_host_with_confirmation
    ::ReservationMailer.notify_host_with_confirmation(reservation)
  end

  def notify_host_without_confirmation
    ::ReservationMailer.notify_host_without_confirmation(reservation)
  end

  def pre_booking
    ::ReservationMailer.pre_booking(reservation)
  end

  private

  def reservation
    Reservation.last || FactoryGirl.create(:reservation_in_san_francisco)
  end

end
