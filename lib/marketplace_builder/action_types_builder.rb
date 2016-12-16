# frozen_string_literal: true
module MarketplaceBuilder
  module ActionTypesBuilder
    def update_action_types_for_object(object, attributes)
      attributes ||= {}
      unused_attrs = if attributes.empty?
                       object.action_types
                     else
                       object.action_types.where('type NOT IN (?)', attributes.map { |attr| attr['type'] })
                     end

      unused_attrs.each { |at| logger.debug "Removing unused action type: #{at.type}" }
      unused_attrs.destroy_all

      attributes.each do |attribute|
        attribute = attribute.symbolize_keys
        type = attribute.delete(:type)

        create_action_type(object, type, default_action_properties.merge(attribute))
        logger.debug "Creating action type: #{type}"
      end
    end

    def create_action_type(object, type, hash)
      hash = hash.with_indifferent_access
      action_type = object.action_types.where(type: type).first_or_initialize

      action_type.assign_attributes(hash)
      action_type.save!
      action_type
    end

    def default_action_properties
      {
        enabled: true,
        allow_no_action: false
      }
    end
  end
end
