class FormAttributes

  def user
    [
      :email, :phone, :avatar, :name, :first_name, :middle_name, :last_name, :approval_requests
    ] + User.public_custom_attributes_names(InstanceProfileType.first.try(:id)) +
    Category.users.roots.map { |k| ('Category - ' + k.name).to_sym }.flatten
  end

  def company
    [
      :name,
      :url,
      :email,
      :description,
      :address,
      :industries,
      :payments_mailing_address
    ]
  end

  def location
    [
      :description, :email, :info, :time_zone,
      :phone, :availability_rules, :special_notes,
      :location_type, :photos, :name, :address,
    ]
  end

  def transactable(transactable_type = nil)
    [
      :name, :description, :availability_rules, :price, :currency, :photos,
      :approval_requests, :quantity, :book_it_out, :exclusive_price, :action_rfq,
      :confirm_reservations, :capacity
    ] +
    Transactable.public_custom_attributes_names(transactable_type.id).map { |k| Hash === k ? k.keys : k }.flatten +
    transactable_type.categories.roots.map { |k| ('Category - ' + k.name).to_sym }.flatten
  end

  def dashboard_transactable(transactable_type = nil)
    [
      :confirm_reservations, :name, :description, :location_id, :approval_requests,
      :enabled, :amenity_types, :price, :currency, :schedule, :photos,
      :waiver_agreement_templates, :documents_upload, :quantity, :book_it_out,
      :exclusive_price, :action_rfq, :capacity
    ] +
    Transactable.public_custom_attributes_names(transactable_type.id).map { |k| Hash === k ? k.keys : k }.flatten +
    transactable_type.categories.roots.map { |k| ('Category - ' + k.name).to_sym }.flatten
  end

  def product(product_type = nil)
    [
      :name,
      :description,
      :photos,
      :price,
      :quantity,
      :integrated_shipping,
      :shipping_info,
      :action_rfq,
      :documents_upload
    ] +
    Spree::Product.public_custom_attributes_names(product_type.id).map { |k| Hash === k ? k.keys : k }.flatten +
    product_type.categories.roots.map { |k| ('Category - ' + k.name).to_sym }.flatten
  end
end

