module Categorizable
  extend ActiveSupport::Concern

  included do
    has_many :categories_categorizables, as: :categorizable
    has_many :categories, through: :categories_categorizables

    attr_accessor :categories_not_required

    validate :validate_mandatory_categories, unless: ->(record) { record.categories_not_required}

    def validate_mandatory_categories
      transactable_type.categories.mandatory.each do |mandatory_category|
        errors.add(mandatory_category.name, I18n.t('errors.messages.blank')) if common_categories(mandatory_category).blank?
      end
    end

    def category_ids=ids
      super(ids.map {|e| e.gsub(/\[|\]/, '').split(',')}.flatten.compact.map(&:to_i))
    end

    def common_categories(category)
      categories & category.descendants
    end

    def common_categories_json(category)
      JSON.generate(common_categories(category).map { |c| { id: c.id, name: c.translated_name }})
    end
  end
end