class @Bookings.Simple.ListingView

  constructor: (@listing, @container) ->
    @setupMultiDatesPicker()
    @quantityField = @container.find('input.quantity')
    @bindModel()
    @bindEvents()

  bindModel: ->
    DNM.Event.observe @listing, 'dateAdded', =>
      @datepicker.setDates(@listing.bookedDates()) if @listing.bookedDates().length > 0

  bindEvents: ->
    @container.find('[data-behavior=showReviewBookingListing]').click (event) =>
      event.preventDefault()
      DNM.Event.notify this, 'reviewTriggered', [@listing]

    quantityChanged = (event) =>
      qty = parseInt($(event.target).val())
      @listing.setDefaultQuantity(qty, true)
      $(event.target).val(qty)

    @quantityField.on 'change', quantityChanged
    @quantityField.on 'keyup', quantityChanged

    DNM.Event.observe @datepicker, 'datesChanged', (dates) =>
      @listing.setDates(dates)

  # Setup the datepicker for the simple booking UI
  setupMultiDatesPicker: ->
    @datepicker = new Bookings.Simple.Datepicker(@container.find(".calendar input"))


