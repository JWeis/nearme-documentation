require 'test_helper'

class ProductFormTest < ActiveSupport::TestCase

  setup do
    PlatformContext.current = PlatformContext.new(FactoryGirl.create(:instance))
    @user = FactoryGirl.create(:user, name: "Firstname Lastname")
    @product = FactoryGirl.create(:base_product, user: @user)
    @zone = FactoryGirl.create(:zone)
  end

  context "boarding form shipping testing" do
    should "save shipping dimensions/weight to master variant" do
      @product_form = ProductForm.new(@product, {})
      @product_form.weight = 101
      @product_form.height = 103
      @product_form.width = 102
      @product_form.depth = 104
      @product_form.shipping_methods_attributes = {"0"=>{"name"=>"sdsadasad", "removed"=>"0", "processing_time"=>"0", "calculator_attributes"=>{"preferred_amount"=>"0.00", "id"=>"24"}, "zones_attributes"=>{"0"=>{"name"=>"Default - 7c9a98679439b6f3f6966f2246d1fe13", "kind"=>"state_based", "state_ids"=>"485" }}}}
      @product.shippo_enabled = true
      @product_form.unit_of_measure = 'metric'
      @product_form.save!

      assert_equal 101, @product.master.weight_user
      assert_equal 103, @product.master.height_user
      assert_equal 102, @product.master.width_user
      assert_equal 104, @product.master.depth_user
    end

    should 'convert shipping dimensions (imperial) to other units of measure' do
      @product_form = ProductForm.new(@product, {})
      @product_form.weight = 101
      @product_form.weight_unit = 'pound'
      @product_form.height = 103
      @product_form.height_unit = 'ft'
      @product_form.width = 102
      @product_form.width_unit = 'ft'
      @product_form.depth = 104
      @product_form.depth_unit = 'ft'

      @product_form.shipping_methods_attributes = {"0"=>{"name"=>"sdsadasad", "removed"=>"0", "processing_time"=>"0", "calculator_attributes"=>{"preferred_amount"=>"0.00", "id"=>"24"}, "zones_attributes"=>{"0"=>{"name"=>"Default - 7c9a98679439b6f3f6966f2246d1fe13", "kind"=>"state_based", "state_ids"=>"485" }}}}
      @product.shippo_enabled = true
      @product_form.unit_of_measure = 'imperial'
      @product_form.save!

      @product.master.reload
      assert_equal 101*16, @product.master.weight
      assert_equal 103*12, @product.master.height
      assert_equal 102*12, @product.master.width
      assert_equal 104*12, @product.master.depth
    end

    should 'convert shipping dimensions (metric) to other units of measure' do
      @product_form = ProductForm.new(@product, {})
      @product_form.weight = 101
      @product_form.weight_unit = 'kg'
      @product_form.height = 103
      @product_form.height_unit = 'cm'
      @product_form.width = 102
      @product_form.width_unit = 'm'
      @product_form.depth = 104
      @product_form.depth_unit = 'cm'

      @product_form.shipping_methods_attributes = {"0"=>{"name"=>"sdsadasad", "removed"=>"0", "processing_time"=>"0", "calculator_attributes"=>{"preferred_amount"=>"0.00", "id"=>"24"}, "zones_attributes"=>{"0"=>{"name"=>"Default - 7c9a98679439b6f3f6966f2246d1fe13", "kind"=>"state_based", "state_ids"=>"485" }}}}
      @product.shippo_enabled = true
      @product_form.unit_of_measure = 'metric'
      @product_form.save!

      @product.master.reload
      assert_equal 3562.67.round, @product.master.weight.round
      assert_equal 40.5512.round, @product.master.height.round
      assert_equal 4015.75.round, @product.master.width.round
      assert_equal 40.94.round, @product.master.depth.round
    end
  end

end

