module MarketplaceBuilder
  module BuilderTests
    class ShouldImportLiquidViews < ActiveSupport::TestCase
      def initialize(instance)
        @instance = instance
      end

      def execute!
        liquid_view = @instance.instance_views.where(view_type: 'view').last
        assert_equal liquid_view.body.strip, '<h1>Hello</h1>'
      end
    end
  end
end