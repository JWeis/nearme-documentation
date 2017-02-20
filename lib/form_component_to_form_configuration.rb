# frozen_string_literal: true
class FormComponentToFormConfiguration
  ADDRESS_HASH = {
    address: {},
    should_check_address: {},
    local_geocoding: {},
    latitude: {},
    longitude: {},
    formatted_addres: {},
    street: {},
    suburb: {},
    city: {},
    state: {},
    country: {},
    postcode: {},
    address_components: {}
  }.freeze

  def initialize(instances)
    @instances = instances
  end

  def go!
    @instances.find_each do |i|
      puts "Instance: #{i.name}"
      i.set_context!
      signup_forms!
      update_profile_form!
    end
  end

  protected

  def user_attributes
    @user_attributes ||= (User.columns.map(&:name) + %w(current_address tags mobile_phone))
  end

  def user_profile_attributes
    @user_profile_attributes ||= UserProfile.columns.map(&:name)
  end

  def update_profile_form!
    puts "\tUpdating Update Profile Forms"
    [
      { Default: FormComponent.where(form_type: 'instance_profile_types', form_componentable: PlatformContext.current.instance.default_profile_type).first },
      { Enquirer: FormComponent.where(form_type: 'buyer_profile_types', form_componentable: PlatformContext.current.instance.buyer_profile_type).first },
      { Lister: FormComponent.where(form_type: 'seller_profile_types', form_componentable: PlatformContext.current.instance.seller_profile_type).first }
    ].each do |el|
      fc_role = el.keys.first

      if [5011, 132].include?(PlatformContext.current.instance.id)
        puts "Configuration for devmesh/hallmark (#{PlatformContext.current.instance.id})"
        # hardcode fields for devmesh / hallmark :)
        configuration = community_configuration
      else
        case fc_role
        when :Default
          create_form_configuration(base_form: UserUpdateProfileForm, name: "Default Update", configuration: build_configuration_based_on_form_components(el.values.first, 'default'))
          create_form_configuration(base_form: UserUpdateProfileForm, name: "Lister Update", configuration: build_configuration_based_on_form_components(el.values.first, 'seller'))
          create_form_configuration(base_form: UserUpdateProfileForm, name: "Enquirer Update", configuration: build_configuration_based_on_form_components(el.values.first, 'buyer'))
        when :Enquirer
          create_form_configuration(base_form: UserUpdateProfileForm, name: "Enquirer Update", configuration: build_configuration_based_on_form_components(el.values.first, 'buyer'))
        when :Lister
          create_form_configuration(base_form: UserUpdateProfileForm, name: "Lister Update", configuration: build_configuration_based_on_form_components(el.values.first, 'seller'))
        end
      end
    end
  end

  def create_form_configuration(base_form:, name:, configuration:)
    if  configuration.present?
      fc = FormConfiguration.where(base_form: base_form, name: name).first_or_initialize
      fc.configuration = configuration
      fc.save!
    else
      puts "Skipping #{base_form} -> #{name}"
    end
  end

  def build_configuration_based_on_form_components(form_component, role)
    configuration = {}
    if form_component.nil?
      puts "\t\tError: can't find form component"
    else
      puts "\tForm component: #{form_component.form_type}"
      form_component.form_fields.each do |k|
        model = k.keys.first
        field = k.values.last
        # puts "\tProcessing: #{model}: #{field}"
        next if model == 'buyer' && role == 'seller'
        next if model == 'seller' && role == 'buyer'
        next if %w(email password).include?(field)
        if model == 'user' && user_attributes.include?(field) || (model == 'buyer' && field == 'tags') || field == 'company_name'
          field = 'tag_list' if field == 'tags'
          if field == 'current_address'
            configuration[field.to_sym] = ADDRESS_HASH
          else
            configuration['country_name'] = ValidationBuilder.new(PlatformContext.current.instance.default_profile_type, 'country_name').build if field == 'mobile_number' || field == 'phone' || field == 'mobile_phone'
            configuration['mobile_number'] = ValidationBuilder.new(PlatformContext.current.instance.default_profile_type, 'mobile_number').build if field == 'phone' || field == 'mobile_phone'
            configuration[field] = ValidationBuilder.new(PlatformContext.current.instance.default_profile_type, field).build.merge(ValidationBuilder.new(PlatformContext.current.instance.send("#{role}_profile_type"), field).build) unless field == 'mobile_phone'
          end
          if %w(name first_name email).include?(field)
            configuration[field][:validation] ||= {}
            configuration[field][:validation][:presence] = {}
          end
        else
          model = 'default' if model == 'user'
          configuration[:"#{model}_profile"] ||= { validation: { presence: {} } }
          if user_profile_attributes.include?(field)
            configuration[:"#{model}_profile"][field] = ValidationBuilder.new(PlatformContext.current.instance.send(:"#{model}_profile_type"), field).build
          elsif field == 'unavailable_periods'
            configuration[:"#{model}_profile"][:availability_template] = {}
          elsif field.include?('Category -')
            field = field.sub('Category - ', '')
            configuration[:"#{model}_profile"][:categories] ||= { validation: { presence: {} } }
            configuration[:"#{model}_profile"][:categories][field] = ValidationBuilder.new(Category.find_by(name: field), field).build
          elsif field.include?('Custom Model -')
            field = field.sub('Custom Model - ', '')
            configuration[:"#{model}_profile"][:customizations] ||= { validation: { presence: {} } }
            configuration[:"#{model}_profile"][:customizations][field] ||= {}
            custom_model_type = CustomModelType.find_by(name: field)
            custom_model_type.custom_attributes.each do |ca|
              if ca.uploadable?
                if ca.attribute_type == 'photo'
                  configuration[:"#{model}_profile"][:customizations][field][:custom_images] ||= {}
                  configuration[:"#{model}_profile"][:customizations][field][:custom_images][ca.id.to_s] = ValidationBuilder.new(custom_model_type, ca.name).build
                  # if at least one image is required, we need to add validation to custom_images, not only custom_images[<attr.id>]
                  configuration[:"#{model}_profile"][:customizations][field][:custom_images][:validation] = { presence: {} } if configuration[:"#{model}_profile"][:customizations][field][:custom_images][ca.id.to_s][:validation].present?
                elsif ca.attribute_type == 'file'
                  configuration[:"#{model}_profile"][:customizations][field][:custom_attachments] ||= {}
                  configuration[:"#{model}_profile"][:customizations][field][:custom_attachments][ca.id.to_s] = ValidationBuilder.new(custom_model_type, ca.name).build
                  # if at least one attachment is required, we need to add validation to custom_attachments, not only custom_attachments[<attr.id>]
                  configuration[:"#{model}_profile"][:customizations][field][:custom_attachments][:validation] = { presence: {} } if configuration[:"#{model}_profile"][:customizations][field][:custom_attachments][ca.id.to_s][:validation].present?
                else
                  raise NotImplementedError, "Unknown uploadable attribute type: #{ca.attribute_type}"
                end
              else
                configuration[:"#{model}_profile"][:customizations][field][:properties] ||= {}
                configuration[:"#{model}_profile"][:customizations][field][:properties][ca.name] = ValidationBuilder.new(custom_model_type, ca.name).build
              end
            end
          elsif (ca = PlatformContext.current.instance.send(:"#{model}_profile_type").custom_attributes.where(name: field).first).present?
            if ca.uploadable?
              if ca.attribute_type == 'photo'
                configuration[:"#{model}_profile"][:custom_images] ||= {}
                configuration[:"#{model}_profile"][:custom_images][ca.id.to_s] = ValidationBuilder.new(PlatformContext.current.instance.send(:"#{model}_profile_type"), ca.name).build
                # if at least one image is required, we need to add validation to custom_images, not only custom_images[<attr.id>]
                configuration[:"#{model}_profile"][:custom_images][:validation] = { presence: {} } if configuration[:"#{model}_profile"][:custom_images][ca.id.to_s][:validation].present?
              elsif ca.attribute_type == 'file'
                configuration[:"#{model}_profile"][:custom_attachments] ||= {}
                configuration[:"#{model}_profile"][:custom_attachments][ca.id.to_s] = ValidationBuilder.new(PlatformContext.current.instance.send(:"#{model}_profile_type"), ca.name).build
                # if at least one attachment is required, we need to add validation to custom_attachments, not only custom_attachments[<attr.id>]
                configuration[:"#{model}_profile"][:custom_attachments][:validation] = { presence: {} } if configuration[:"#{model}_profile"][:custom_attachments][ca.id.to_s][:validation].present?
              else
                raise NotImplementedError, "Unknown uploadable attribute type: #{ca.attribute_type}"
              end
            else
              configuration[:"#{model}_profile"][:properties] ||= { validation: { presence: {} } }
              configuration[:"#{model}_profile"][:properties][field] = ValidationBuilder.new(PlatformContext.current.instance.send(:"#{model}_profile_type"), field).build
            end
          else
            puts "\t\tSkipping field - #{field}, can't find it"
          end
        end
      end
    end
    configuration
  end

  def community_configuration
    {
      name: { validation: { presence: {} } },
      cover_image: { validation: {} },
      avatar: { validation: {} },
      current_address: ADDRESS_HASH,
      default_profile: {
        properties: {
          video_url: { validation: {} },
          short_bio: { validation: {} },
          about_me: { validation: {} }
        }
      }
    }
  end

  def signup_forms!
    puts "\tUpdating Signup Forms"
    { seller: 'Lister', buyer: 'Enquirer', default: 'Default' }.each do |role, conf_role|
      puts "\tform for: #{role}"
      form_component = FormComponent.find_by(form_type: "FormComponent::#{role.upcase}_REGISTRATION".constantize)
      if form_component.nil?
        puts "\t\tError: can't find form component for #{role}"
        next
      end
      configuration = {}
      form_component.form_fields.each do |k|
        model = k.keys.first
        field = k.values.last
        field = 'mobile_number' if field == 'phone' || field == 'mobile_phone'
        if model != 'user'
          puts "\t\tWarning: undefined model: #{model}"
          next
        end
        next if %w(email password).include?(field)
        configuration[field] = { validation: { presence: true } }
        puts "\t\tAdding: #{field} (for #{model})"
      end

      base_form = case conf_role
                  when 'Enquirer'
                    UserSignup::DefaultUserSignup
                  when 'Lister'
                    UserSignup::ListerUserSignup
                  when 'Default'
                    UserSignup::EnquirerUserSignup
                  end
      fc = FormConfiguration.where(base_form: base_form, name: "#{conf_role} Signup")
        .first_or_create!
      fc.update_attribute(:configuration, configuration)
    end
  end

  class ValidationBuilder
    def initialize(validatable, field)
      @validatable = validatable
      @field = field
    end

    def build
      if custom_validators.any?
        {
          validation: custom_validators.each_with_object({}) do |cv, validation|
            validation.merge!(cv.validation_rules.deep_symbolize_keys)
          end
        }
      else
        {}
      end
    end

    protected

    def custom_validators
      if @validatable.is_a?(Category)
        if @validatable.mandatory?
          [OpenStruct.new(validation_rules: { presence: true })]
        else
          [OpenStruct.new(validation_rules: {})]
        end
      elsif @validatable.nil?
        [OpenStruct.new(validation_rules: {})]
      else
        (@validatable.custom_attributes.where(name: @field).first || @validatable).custom_validators.where(field_name: @field)
      end
    end
  end
end
