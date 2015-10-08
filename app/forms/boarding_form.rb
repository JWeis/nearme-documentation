class BoardingForm < Form

  attr_accessor :product_form, :company, :user, :user_attributes, :company_attributes

  delegate :draft?, to: :@product

  # Validations:

  validate :validate_product, :validate_company

  def validate_product
    unless @product_form.valid?
      @product_form.errors.full_messages.each do |m|
        errors.add(:product_form, m)
      end
    end
  end

  def validate_company
    unless @company.valid?
      @company.errors.full_messages.each do |m|
        errors.add(:company, m)
      end
    end
  end

  def validate_user
    unless @user.valid?
      @user.errors.full_messages.each do |m|
        errors.add(:user, m)
      end
    end
  end

  def initialize(user, product_type)
    @user = user
    @company = @user.companies.first || @user.companies.build(:creator_id => @user.id)
    @product = @company.products.where(product_type: product_type).first || @company.products.build(user_id: @user.id, product_type_id: product_type.id)
    @product.user = @user if @product.user.blank?
    @product_form = ProductForm.new(@product)
  end

  def submit(params)
    params[:product_form].merge!(draft: params.delete(:draft).nil? ? false : true)

    store_attributes(params)
    @user.assign_attributes(params[:user_attributes])
    @company.assign_attributes(params[:company_attributes])

    if draft? || valid?
      @user.save!(validate: !draft?)
      @company.save!(validate: !draft?)
      @product_form.save!(validate: !draft?)

      true
    else
      assign_all_attributes
      false
    end
  end

  def persisted?
    true
  end

  def product_form=(attributes)
    @product_form.store_attributes(attributes)
  end

  def assign_all_attributes
    @store_name = @company.name
    @product_form.assign_all_attributes
  end

end
