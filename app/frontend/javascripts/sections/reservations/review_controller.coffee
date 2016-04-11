module.exports = class ReservationReviewController

  require('./../../../vendor/jquery-ui-datepicker');

  constructor: (@container) ->
    @dateInput = @container.find('.jquery-datepicker');
    if @dateInput.length > 0
      OverlappingReservationsController = require('./overlapping_reservations')
      @overlappingCheck = new OverlappingReservationsController(@container.find('[data-reservation-dates-controller]'));
      @initializeDatepicker()
      @disableHours(@dateInput.val())
      @overlappingCheck.checkNewDate()

  initializeDatepicker: ->
    @dateInput.datepicker
      altField: '#reservation_request_dates'
      altFormat: 'yy-mm-dd'
      dateFormat: window.I18n.dateFormats['day_month_year'].replace('%d', 'dd').replace('%m', 'mm').replace('%Y', 'yy')
      beforeShowDay: (date) ->
        opened_days = $(@).data('open-on-days')
        [ opened_days.indexOf(date.getDay()) > -1 ]
      onSelect: (date_string) =>
        @disableHours(date_string)
        @overlappingCheck.checkNewDate()

  disableHours: (date_string)->
    date = new Date(date_string)
    ranges = @dateInput.data('days-with-ranges')[date.getDay()]
    if $('#reservation_request_start_time option').length > 0
      $('#reservation_request_start_time option').attr 'disabled', 'disabled'
      $('#reservation_request_start_time option').each (i, option) ->
        $.each ranges, (i, val) ->
          time = parseInt($(option).data('time'))
          if time >= val[0] and time <= val[1]
            $(option).attr 'disabled', false
