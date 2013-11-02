class ReservationsController < ApplicationController
  before_filter :authenticate_user!, :except => :new
  before_filter :fetch_reservations
  before_filter :fetch_reservation, :only => [:user_cancel]
  before_filter :fetch_current_user_reservation, :only => [:export, :host_rating]

  before_filter :only => [:user_cancel] do |controller|
    unless allowed_events.include?(controller.action_name)
      flash[:error] = t('flash_messages.reservations.invalid_operation')
      redirect_to redirection_path
    end
  end

  def user_cancel
    if @reservation.user_cancel
      ReservationMailer.enqueue.notify_host_of_cancellation(platform_context, @reservation)
      event_tracker.cancelled_a_booking(@reservation, { actor: 'guest' })
      event_tracker.updated_profile_information(@reservation.owner)
      event_tracker.updated_profile_information(@reservation.host)
      flash[:deleted] = t('flash_messages.reservations.reservation_cancelled')
    else
      flash[:error] = t('flash_messages.reservations.reservation_not_confirmed')
    end
    redirect_to redirection_path
  end

  def index
    redirect_to upcoming_reservations_path
  end

  def export
    respond_to do |format|
      format.ics do
        calendar = RiCal.Calendar do |cal|
          cal.add_x_property 'X-WR-CALNAME', 'Desks Near Me' 
          cal.add_x_property 'X-WR-RELCALID', "#{current_user.id}"
          @reservation.periods.each do |period|
            cal.event do |event|
              event.description = @reservation.listing.description
              event.summary = @reservation.listing.name
              event.uid = "#{@reservation.id}_#{period.date.to_s}"
              hour = period.start_minute/60.floor
              minute = period.start_minute - (hour * 60)
              event.dtstart = period.date.strftime("%Y%m%dT") + "#{"%02d" % hour}#{"%02d" % minute}00"
              hour = period.end_minute/60.floor
              minute = period.end_minute - (hour * 60)
              event.dtend = period.date.strftime("%Y%m%dT") + "#{"%02d" % hour}#{"%02d" % minute}00"
              event.created = @reservation.created_at
              event.last_modified = @reservation.updated_at
              event.location = @reservation.listing.address
              event.url = bookings_dashboard_url(id: @reservation.id)
            end
          end
        end

        render :text => calendar.to_s.gsub("\n", "\r\n")
      end
    end
  end

  def upcoming
    unless current_user.reservations.empty?
      @reservations = current_user.reservations.not_archived.to_a.sort_by(&:date)
      @reservation = params[:id] ? current_user.reservations.find(params[:id]) : nil
    end
    render :index
  end

  def archived
    @reservations = current_user.reservations.archived.to_a.sort_by(&:date)
    render :index
  end

  def host_rating
    existing_host_rating = HostRating.where(reservation_id: @reservation.id,
                                            author_id: current_user.id)
    if existing_host_rating.blank?
      upcoming
    else
      flash[:notice] = t('flash_messages.host_rating.already_exists')
      redirect_to root_path
    end
  end

  protected

  def fetch_reservations
    @reservations = current_user.reservations
  end

  def fetch_reservation
    @reservation = @reservations.find(params[:id])
  end

  def fetch_current_user_reservation
    @reservation = current_user.reservations.find(params[:id])
  end

  def allowed_events
    ['user_cancel']
  end

  def current_event
    params[:event].downcase.to_sym
  end

  def redirection_path
    if @reservation.owner.id == current_user.id
      bookings_dashboard_path
    else
      manage_guests_dashboard_path
    end
  end

end
