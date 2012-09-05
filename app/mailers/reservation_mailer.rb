class ReservationMailer < DesksNearMeMailer

  def pending_confirmation(reservation)
    setup_defaults(reservation)
    generate_mail("Your reservation is pending confirmation")
  end

  def reservation_confirmed(reservation)
    setup_defaults(reservation)
    generate_mail("Your reservation has been confirmed")
  end

  def unconfirmed_reservation_created(reservation)
    setup_defaults(reservation)

    @user = @listing.creator
    @url  = dashboard_url

    generate_mail("A new reservation requires your confirmation")
  end

  def confirmed_reservation_created(reservation)
    setup_defaults(reservation)
    @user = @listing.creator
    @reserver = reservation.owner.name
    generate_mail("You have a new reservation")
  end

  def reservation_rejected(reservation)
    setup_defaults(reservation)
    generate_mail("Sorry, your reservation at #{@listing} has been rejected")
  end

  def reservation_cancelled_by_owner(reservation)
    setup_defaults(reservation)
    generate_mail("Your reservation at #{@listing} has been cancelled by the owner")
  end

  def reservation_cancelled_by_user(reservation)
    setup_defaults(reservation)
    @user = @listing.creator
    generate_mail("A reservation has been cancelled")
  end

  private
    def setup_defaults(reservation)
      @reservation   = reservation
      @listing = reservation.listing
      @user      = reservation.owner
    end

    def generate_mail(subject)
      mail :subject => "[DesksNear.Me] #{subject}",
           :to      => @user.email
    end
end
