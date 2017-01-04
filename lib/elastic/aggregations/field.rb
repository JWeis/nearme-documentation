module Elastic
  module Aggregations
    class Field
      BUCKET_SIZE = 25

      def initialize(label:, field:, type: :terms, size: nil)
        @field = field
        @label = label
        @type = type || :terms
        @size = size
      end

      def enabled?
        @field.present?
      end

      def body
        {
          @label => {
            @type => field_meta
          }
        }
      end

      def field_meta
        field_data = default_field_data
        field_data[:size] = @size if @size
        field_data[:order] = { '_term' => 'asc' } if sortable?
        field_data
      end

      def default_field_data
        {
          field: @field
        }
      end

      def sortable?
        @type == :terms
      end

      def size
        return if @field != :terms

        @size || BUCKET_SIZE
      end
    end
  end
end