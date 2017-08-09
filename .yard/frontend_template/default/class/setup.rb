# frozen_string_literal: true
def init
  is_liquid_tag = object.file.match(/^app\/liquid_tags\/.+?\.rb$/)
  is_form = object.file.match(/^app\/forms\/.+?\.rb$/)

  return unless object.path.match(/Drop$/) || is_liquid_tag || is_form

  super
  if is_liquid_tag
    sections.delete_if do |section|
      name = section.name.to_s
      !(name == 'pre_docstring' || name.match(/yard_frontend_template_default_docstring/))
    end
  end
  sections.place(:subclasses).before(:children)
  sections.place(:constructor_details, [T('method_details')]).before(:methodmissing)
end
