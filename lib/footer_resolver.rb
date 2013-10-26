require 'singleton'

class FooterResolver < DbViewResolver
  include Singleton

  def find_templates(name, prefix, partial, details) 
    return [] unless details[:theme]
    return [] unless name == 'theme_footer'
    return [] unless details[:handlers].include?(:liquid)

    conditions = {
      path:        normalize_path(name, prefix),
      partial:     partial || false,
      theme_id:    details[:theme]
    }

    FooterTemplate.where(conditions).map do |record|
      initialize_template(record, normalize_array(details[:formats]).first)
    end
  end
end
