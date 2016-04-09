module CategoriesHelper
  def build_categories_hash_for_object(object, root_categories)
    @object_permalinks = object.categories.pluck(:permalink)
    @root_categories = @object_permalinks.map { |p| p.split('/')[0] }.uniq
    categories = {}
    root_categories.find_each do |category|
      children = if @root_categories.include?(category.permalink)
                   category.children.map { |child| build_value_for_category(child) }.compact
                 else
                   []
                 end
      categories[category.name] = { 'name' => category.translated_name, 'children' => children }
    end
    categories
  end

  def build_categories_hash(root_categories)
    categories = {}
    root_categories.find_each do |category|
      children = category.children.map { |child| build_all_values_for_category(child) }.compact
      categories[category.name] = { 'name' => category.translated_name, 'children' => children }
    end
    categories
  end

  def build_formatted_categories(object)
    if @formatted_categories.nil?
      @formatted_categories = {}
      parent_ids = object.categories.map(&:parent_id)
      object.categories.reject{|c| c.id.in?(parent_ids)}.map do |category|
        @formatted_categories[category.root.name] ||= {'name' => category.root.translated_name, 'children' => []}
        @formatted_categories[category.root.name]['children'] << category.self_and_ancestors.reject{|c| c.root? }.map(&:translated_name).join(': ')
      end
      @formatted_categories.each_pair{|parent, values| @formatted_categories[parent]['children'] = values['children'].join(', ')}
    end
    @formatted_categories
  end

  protected

  def build_value_for_category(category)
    if @object_permalinks.include?(category.permalink)
      if category.leaf?
        category.translated_name
      else
        { category.translated_name => category.children.map { |child| build_value_for_category(child) }.compact }
      end
    end
  end

  def build_all_values_for_category(category)
    if category.leaf?
      category.translated_name
    else
      { category.translated_name => category.children.map { |child| build_all_values_for_category(child) }.compact }
    end
  end
end
