module.exports = {
    load: function(element, event) {
        $('[data-add-favorite-button]').each(function() {
            var container = $(this);
            var data = {
                'object_type': container.data('object-type'),
                'link_to_classes': container.data('link-to-classes')
            };
            $.get(container.data('path'), data, function(response){
                $(container).html(response);
            });
        });
    },

    init: function(element, event) {
        $(element).find('[data-action-link]').on('click', function(event){
            $.ajax({
                url: $(this).attr('href'),
                method: $(this).data('method'),
                dataType: "script"
            });
            event.preventDefault();
            return false;
        });
    }
}