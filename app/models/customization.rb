class Customization < ActiveRecord::Base
  acts_as_paranoid
  auto_set_platform_context
  scoped_to_platform_context

  has_custom_attributes target_type: 'CustomModelType', target_id: :custom_model_type_id

  belongs_to :instance
  belongs_to :custom_model_type
  belongs_to :customizable, polymorphic: true, touch: true


  def to_liquid
    @customization_drop ||= CustomizationDrop.new(self)
  end

end