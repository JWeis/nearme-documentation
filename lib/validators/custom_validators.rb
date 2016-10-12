class CustomValidators < ActiveModel::Validator
  def validate(record)
    return true if record.skip_custom_attribute_validation || record.custom_validators.blank?
    return true if record.try(:draft?)

    record.custom_validators.each do |validator|
      next if validator.validation_only_on_update? && record.new_record?
      if validator.validation_rules.present?
        validator.validation_rules.each do |validation_rule_type, validation_rule_options|
          validation_rule_options ||= {}
          name = validation_rule_options.fetch('redirect', validator.field_name)
          options = ({ attributes: name }.merge(validation_rule_options)).symbolize_keys

          klass = case validation_rule_type.to_sym
                  when :presence
                    ActiveModel::Validations::PresenceValidator
                  when :inclusion
                    ActiveModel::Validations::InclusionValidator
                  when :numericality
                    ActiveModel::Validations::NumericalityValidator
                  when :length
                    ActiveModel::Validations::LengthValidator
                  else
                    fail "Unknown validation type: #{validation_rule_type}"
                  end
          klass.new(options).validate(record)
        end
      end
      if validator.valid_values.present? && record[validator.field_name].present?
        unless validator.valid_values.map { |s| s.mb_chars.downcase }.include?(record[validator.field_name].try(:mb_chars).try(:downcase))
          record.errors.add(validator.field_name, :inclusion, value: record[validator.field_name])
        end
      end
      if validator.regex_validation? && validator.regex_expression.present?
        unless /#{validator.regex_expression}/.match(record[validator.field_name])
          record.errors.add(validator.field_name, I18n.t('errors.messages.has_an_invalid_format'))
        end
      end
    end
  end
end
