class ReservationMailer < InstanceMailer
  layout 'mailer'

  def notify_guest_of_cancellation(reservation)
    setup_defaults(reservation)
    generate_mail
  end

  def notify_guest_of_confirmation(reservation)
    setup_defaults(reservation)
    generate_mail
  end

  def notify_guest_of_rejection(reservation)
    setup_defaults(reservation)
    generate_mail
  end

  def notify_guest_with_confirmation(reservation)
    setup_defaults(reservation)
    generate_mail
  end

  def notify_host_of_cancellation(reservation)
    setup_defaults(reservation)
    @user = @listing.creator
    generate_mail
  end

  def notify_host_of_confirmation(reservation)
    setup_defaults(reservation)
    @user = @listing.creator
    generate_mail
  end
  
  def notify_guest_of_expiration(reservation)
    setup_defaults(reservation)
    generate_mail
  end
  
  def notify_host_of_expiration(reservation)
    setup_defaults(reservation)
    @user = @listing.creator
    generate_mail
  end
  
  def notify_host_with_confirmation(reservation)
    setup_defaults(reservation)
    @user = @listing.creator
    @url  = manage_guests_dashboard_url(:token => @user.authentication_token)
    generate_mail
  end

  def notify_host_without_confirmation(reservation)
    setup_defaults(reservation)
    @user = @listing.creator
    @url  = manage_guests_dashboard_url(:token => @user.authentication_token)
    @reserver = reservation.owner.name
    generate_mail
  end

  if defined? MailView
    class Preview < MailView

      def notify_guest_of_cancellation
        ::ReservationMailer.notify_guest_of_cancellation(reservation)
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

      def notify_host_of_cancellation
        ::ReservationMailer.notify_host_of_cancellation(reservation)
      end

      def notify_host_of_confirmation
        ::ReservationMailer.notify_host_of_confirmation(reservation)
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

      private

        def reservation
          Reservation.last || FactoryGirl.create(:reservation)
        end

    end
  end

  private

  def setup_defaults(reservation)
    @reservation  = reservation
    @listing      = reservation.listing.reload
    @user         = reservation.owner
  end

  def generate_mail
    current_instance = @listing.instance

    mail(to: @user.email,
         instance: current_instance)
  end
end
