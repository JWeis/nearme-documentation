module.exports = class BookingType

  constructor: (el)->
    @container = $(el)
    @input = $('input[data-booking-type]')
    @tabs = @container.find('[data-toggle="tab"]')
    @availability = $('.listing-availability')
    @bindEvents()
    @initTabs()

  bindEvents: =>
    @tabs.on 'show.bs.tab', (e) =>
      @changeBookingType(e.target)

    @input.on 'change', (e) =>
      if @input.val() == 'schedule'
        @availability.addClass('form-section-disabled')
        @availability.find('input').prop('disabled', true)
      else
        @availability.removeClass('form-section-disabled')
        @availability.find('input').prop('disabled', false)

  changeBookingType: (el)->
    @input.val $(el).data('booking-type')
    if $(el).data('booking-type') == 'regular'
      $('.price-options input[type=checkbox]').trigger('change')
    @input.trigger('change')

  initTabs: ->
    if @input.val() != 'schedule' && @input.val() != 'subscription'
      @tabs.filter("[data-booking-type='regular']").tab('show')
    else
      @tabs.filter("[data-booking-type='#{@input.val()}']").tab('show')