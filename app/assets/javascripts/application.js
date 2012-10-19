// Desks Near Me
//
// Require legacy jQuery dependent code first
//= require ./vendor/jquery-1.4.1.js
//= require ./vendor/jquery.overlay.js
//= require ./vendor/jquery-ui-1.8.23.custom.min.js
//= require ./vendor/jquery.address-1.3.min
//= require search
//* require ./vendor/fancybox/jquery.fancybox-1.3.1.pack.js
//
// Require new jQuery to override (NB: This is so HAX)
//= require ./vendor/jquery
//= require ./vendor/rails
//= require ./vendor/modernizr.js
//= require ./vendor/jquery.cookie.js
//= require tile.stamen.js
//
//= require_self
//
// Standard components
//= require ./components/multiselect
//
// Sections
//= require ./sections/search
//= require ./sections/locations/location_form_controller
//= require ./sections/locations/availability_rules_controller
//= require ./sections/listings/listing_form_controller
//= require ./sections/listings/space_controller


window.DNM = {
  initialize : function() {
    this.initializeComponents();
  },

  initializeComponents: function(scope) {
    Multiselect.initialize(scope)
  }
}

$(function() {
  DNM.initialize()
})

// FIXME: Hax to initialize jQuery UI on 2 versions of JQuery temporaryily
initializeJQueryUI(jQuery);

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$(document).on('click', 'a[rel=submit]', function(e) {
  var form = $(this).closest('form');
  if (form.length > 0) {
    e.preventDefault();
    form.submit();
    return false;
  }
});

function doListingGoogleMaps() {
  return;
  var locations = $(".map address"),
      map       = null;

  $.each(locations, function(index, location) {
    location        = $(location);
    var latlng      = new google.maps.LatLng(location.attr("data-lat"), location.attr("data-lng"));

    if(!map) {
      var layer = "toner";
      map = new google.maps.Map(document.getElementById("map"), {
        zoom: 13,
        mapTypeId: layer,
        mapTypeControl: false,
        center: latlng
      });
      map.mapTypes.set(layer, new google.maps.StamenMapType(layer));
    }

    var image       = location.attr("data-marker");
    var beachMarker = new google.maps.Marker({
      position: latlng,
      map: map,
      icon: image
    });
  });
}

function doInlineReservation() {
  $("#content").on("click", "td.day .details.availability a", function(e) {
    e.stopPropagation();
    e.preventDefault();
    var overlay = jQueryLegacy("body").overlay({ ajax: $(this).attr("href"), position: { my: "top", at: "bottom", of: $(this).parents('td') }, html: 'Working&hellip;', 'class': "context" });
    $(".overlay-container a.cancel").live("click", function(e){
      e.stopPropagation();
      jQueryLegacy(".overlay-container").overlay('close');
      return false;
    });
    return false;
  });
}

function doPhotoFancyBox() {
  $(".fancy-photos a:has(img), .fancy-photos [href$=.jpg], .fancy-photos a[href$=.png], .fancy-photos a[href$=.gif]")
    .attr("rel", "photos").fancybox({
      transitionIn: "elastic",
      transitionOut: "elastic",
      titlePosition: "over",
      padding: 0
    });
}

$(function(){
//  doPhotoFancyBox();
  doInlineReservation();
  doListingGoogleMaps();
});
