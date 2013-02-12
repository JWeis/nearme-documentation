define(['jquery', 'backbone', 'hbs!templates/listings/item', 'hbs!templates/shared/errors', 'bootstrap'], function($, Backbone, listingTemplate, errorsTemplate) {
  var ListingView = Backbone.View.extend({
    template: listingTemplate,
    initialize: function() {
      _.bindAll(this, 'render', '_afterSave', '_showError');
      this.thumbnail_url = this.options.thumbnail_url;
      this._deleteTrigger = '.delete-listing'; // helper for testing
      this._availabilityTrigger = '.edit_listing .availability-rules input[type=radio]'; // helper for testing
    },

    events: {
      "click .save-listing": "save",
      "click .delete-listing": "trash",
      "click .edit_listing .availability-rules input[type=radio]": "availabilityChanged",
      "keyup input#listing_name": "nameChanged"
    },

    render: function() {
      var data = this.model.toJSON();
      data.thumbnail_url = this.thumbnail_url;
      this.$el.html(this.template(data));
      return this;
    },

    nameChanged: function(event) {
      var target = $(event.target);
      target.closest('section.listing').find('span.listing-header').text(target.val());
    },

    availabilityChanged: function(event) {
      var target = event.target;
      var customRules = $(target).closest('.availability-rules').find('.custom-availability-rules');
      if (target.id === "availability_rules_custom") {
        customRules.show();
      } else {
        customRules.hide();
      }

      var deferRule = $(target).closest('.availability-rules').find('#defer_availability_rules');
      if (target.id === "availability_rules_defer") {
        deferRule.val(1);
      } else {
        deferRule.val(0);
      }
    },

    save: function(event) {
      event.preventDefault();
      event.stopPropagation();
      var data = this._serializeData(this.$el.find('.edit_listing'));
      this.model.save(data, {
        success: this._afterSave,
        error: this._showError
      });
    },

    trash: function(event) {
      event.preventDefault();
      event.stopPropagation();
      var result = confirm("Are you sure you want to delete this Listing?");
      if (result === true) {
        this.model.trash();
        var self = this;
        this.$el.fadeOut(400, function() {
          self.remove();
        });
      }
    },

    _afterSave: function(data) {
      var elt = $(this.$el).find('.save-listing span');
     elt.animate({
        opacity: 0.2
      }, 500, function() {
        elt.text('Saved!');
      });
      elt.animate({
        opacity: 1
      });
      elt.animate({
        opacity: 0.2
      }, 500, function() {
        elt.text('Save');
      });
      elt.animate({
        opacity: 1
      }, 1500 );
    },

    _showError: function(data) {
      var msg = $.parseJSON(data.responseText).errors.join(", ");
      var content = errorsTemplate({
        msg: msg
      });
      var id = !this.model.isNew() ? this.model.id : '';
      $('.action', this.$el.find('#listing-for-' + id)).prepend(content);
      $('.alert-error', this.$el).fadeIn();
    },

    _serializeData: function($fragment) {
      var arr = $fragment.serializeArray();
      var pattern = new RegExp(/([a-z_]+)\[([^\]]+)\]\[([^\]]+)\]/); // match my_attributes_array[1][id]
      var data = _(arr).reduce(function(acc, field) {
        if (acc[field.name] && !pattern.test(field.name)) { // deal with array checkbox type like amenities_ids[]
          if (!_.isArray(acc[field.name])) {
            acc[field.name] = [acc[field.name]];
          }
          acc[field.name].push(field.value);
        } else if (pattern.test(field.name)) { // deal with  nested object
          var split = field.name.match(pattern);
          var name = split[1];
          var index = split[2];
          var param = split[3];

          if (!acc[name]) {
            acc[name] = {};
          }
          if (!acc[name][index]) {
            acc[name][index] = {};
          }
          acc[name][index][param] = field.value;
        } else {
          acc[field.name] = field.value;
        }
        return acc;
      }, {});

      return data;
    }
  });
  return ListingView;

});

