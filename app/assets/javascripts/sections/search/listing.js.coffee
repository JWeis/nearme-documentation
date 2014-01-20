# A simple wrapper around the search result data
#
# TODO: At some point we should probalby be retrieving JSON result data rather than
#       HTML elements.
class Search.Listing
  asEvented.call(Listing.prototype)

  @forElement: (el) ->
    el = $(el)
    listing = el.data("mapListing")
    listing ||= new Search.Listing(el)
    el.data("mapListing", listing)
    listing

  constructor: (element) ->
    @_element = $(element)
    @_id  = parseInt(@_element.data('id'), 10)
    @_lat = parseFloat(@_element.data('latitude'))
    @_lng = parseFloat(@_element.data('longitude'))
    @_location = parseInt(@_element.data('location'))
    @_name = @_element.attr('data-name')
    @_number = parseInt(@_element.data('number'))
    @bindEvents()

  # The current implementation of the search results use server-side generated html elements.
  # Since these can change, we want to swap the element we're bound to but still refer to the
  # same client-side Listing object to simplify our event binding and behaviour
  setElement: (element) ->
    if @_element[0] != $(element)[0]
      @_element = $(element)
      @bindEvents()

  setHtml: (html) ->
    @_element.replaceWith(html)
    @setElement(html)

  bindEvents: ->
  
  element: ->
    @_element
  
  id: ->
    @_id

  lat: ->
    @_lat

  lng: ->
    @_lng

  name: ->
    @_name

  latLng: ->
    @_latLng ||= new google.maps.LatLng(@_lat, @_lng)

  location: ->
    @_location

  number: ->
    @_number

  setNumber: (number) ->
    @_number = number

  # The content that goes in the map popup when clicking the marker
  popoverContent: ->
    @_element.find('.listing-map-popover-content').html()

  popoverTitleContent: ->
    @_element.find('.listing-location-title').html()

  # Don't show this result.
  hide: ->
    @_element.hide().addClass('hidden')
