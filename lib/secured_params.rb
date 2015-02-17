class SecuredParams

  def boarding_form
    [
      :draft,
      :store_name,
      company_address_attributes: nested(self.address),
      product_form: nested(self.product_form)

    ]
  end

  def product_form
    [
      :draft,
      :name,
      :description,
      :price,
      :quantity,
      :taxon_ids,
      :shippo_enabled,
      :weight,
      :depth,
      :width,
      :height,
      :weight_unit,
      :depth_unit,
      :width_unit,
      :height_unit,
      :unit_of_measure,
      image_ids: [],
      company_address_attributes: nested(self.address),
      images_attributes: nested(self.spree_image),
      shipping_methods_attributes: nested(self.spree_shipping_method)
    ]
  end

  def instance_shipping_providers
    [
      :shippo_username, :shippo_password,
    ]
  end

  def dimensions_template
    [
      :name,
      :unit_of_measure,
      :weight,
      :height,
      :width,
      :depth,
      :weight_unit,
      :height_unit,
      :width_unit,
      :depth_unit
    ]
  end

  def custom_attribute
    [ :name,
      :attribute_type
    ] + self.custom_attribute_internal
  end

  def custom_attribute_internal
    [
      :html_tag,
      :prompt,
      :default_value,
      :public,
      :label,
      :placeholder,
      :hint,
      :input_html_options,
      :wrapper_html_options,
      :input_html_options_string,
      :wrapper_html_options_string,
      valid_values: []
    ]
  end

  def data_upload
    [
      :csv_file,
      options: [:send_invitational_email, :sync_mode]
    ]

  end

  def instance_admin_role
    [
      :permission_analytics,
      :permission_settings,
      :permission_theme,
      :permission_transfers,
      :permission_inventories,
      :permission_partners,
      :permission_users,
      :permission_pages,
      :permission_manage,
      :permission_blog,
      :permission_support,
      :permission_buysell,
      :permission_shippingoptions,
      :name
    ]
  end

  def shipping_category
    [
      :name
    ]
  end

  def shipping_method
    [
      :name,
      :tax_category_id,
      shipping_category_ids: [],
      zone_ids: []
    ]
  end

  def calculator
    [
      :preferred_amount
    ]
  end

  def tax_category
    [
      :name,
      :description,
      :is_default
    ]
  end

  def tax_rate
    [
      :name,
      :amount,
      :included_in_price,
      :zone_id,
      :tax_category_id,
      :calculator_type
    ]
  end

  def zone
    [
      :name,
      :description,
      :default_tax,
      :kind,
      :country_ids,
      :state_ids,
      state_ids: [],
      country_ids: []
    ]
  end

  def taxonomy
    [
      :name
    ]
  end

  def taxon
    [
      :name,
      :in_top_nav,
      :top_nav_position,
      :parent_id,
      :child_index
    ]
  end

  def search_notification
    [
      :email,
      :latitude,
      :longitude,
      :query
    ]
  end

  def email_template
    [
      :body,
      :path,
      :locale,
      :format
    ]
  end

  def email_layout_template
    [
      :body,
      :path,
      :locale,
      :format
    ]
  end

  def sms_template
    [
      :body,
      :path,
      :locale
    ]
  end

  def blog_instance
    [
      :enabled,
      :name,
      :header,
      :facebook_app_id,
      :header_text,
      :header_motto,
      :header_logo,
      :header_icon,
      owner_attributes: nested([:user_blogs_enabled])
    ]
  end

  def blog_post
    [
      :title,
      :content,
      :exceprt,
      :published_at,
      :slug,
      :author_name,
      :author_biography,
      :author_avatar
    ]
  end

  def user_blog
    [
        :enabled,
        :name,
        :header_image,
        :header_text,
        :header_motto,
        :header_logo,
        :header_icon,
        :facebook_app_id
    ]
  end

  def user_blog_post
    [
        :title,
        :published_at,
        :slug,
        :hero_image,
        :content,
        :excerpt,
        :author_name,
        :author_biography,
        :author_avatar_img,
        :logo
    ]
  end

  def admin_user_blog_post
    user_blog_post + [:highlighted]
  end

  def instance
    [
      :name,
      :skip_company, :mark_as_locked,
      :live_stripe_api_key, :live_stripe_public_key,
      :live_paypal_username, :live_paypal_password,
      :live_paypal_signature, :live_paypal_app_id,
      :live_paypal_client_id,  :live_paypal_client_secret,
      :live_balanced_api_key,  :instance_billing_gateways_attributes,
      :test_stripe_api_key, :test_stripe_public_key,
      :test_paypal_username, :test_paypal_password,
      :test_paypal_signature, :test_paypal_app_id,
      :test_paypal_client_id, :test_paypal_client_secret,
      :test_balanced_api_key,
      :marketplace_password, :password_protected, :test_mode,
      :olark_api_key, :olark_enabled,
      :facebook_consumer_key, :facebook_consumer_secret,
      :twitter_consumer_key, :twitter_consumer_secret,
      :linkedin_consumer_key, :linkedin_consumer_secret,
      :instagram_consumer_key, :instagram_consumer_secret,
      :support_imap_hash, :support_email,
      :paypal_email, :db_connection_string,
      :stripe_currency, :user_info_in_onboarding_flow,
      :default_search_view, :user_based_marketplace_views,
      :searcher_type, :onboarding_verification_required,
      :apply_text_filters, :force_accepting_tos,
      :payment_transfers_frequency,
      :user_blogs_enabled,
      :twilio_consumer_key, :twilio_consumer_secret,
      :test_twilio_consumer_key, :test_twilio_consumer_secret,
      :twilio_from_number, :test_twilio_from_number,
      :service_fee_guest_percent, :service_fee_host_percent,
      :bookable_noun,
      :wish_lists_enabled,
      :wish_lists_icon_set,
      user_required_fields: [],
      transactable_types_attributes: nested(self.transactable_type),
      listing_amenity_types_attributes: nested(self.amenity_type),
      location_amenity_types_attributes: nested(self.amenity_type),
      location_types_attributes: nested(self.location_type),
      instance_payment_gateways_attributes: nested(self.instance_payment_gateway),
      translations_attributes: nested(self.translation),
      domains_attributes: nested(self.domain),
      text_filters_attributes: nested(self.text_filter),
      theme_attributes: self.theme
    ]
  end

  def spree_image
    [
      :position
    ]
  end

  def spree_option_type
    [
      :name,
      :presentation,
      :position,
      option_values_attributes: nested(self.spree_option_value),

    ]
  end

  def spree_option_value
    [
      :name,
      :presentation,
      :position
    ]
  end

  def spree_property
    [
      :name,
      :presentation,
      :position
    ]
  end

  def spree_product_property
    [
      :id,
      :property_name,
      :value,
      :company_id
    ]
  end

  def spree_variant
    [
      :sku,
      :price,
      :cost_price,
      :weight,
      :height,
      :depth,
      :tax_category_id,
      option_value_ids: []
    ]
  end

  def spree_prototype
    [
      :name,
      property_ids: [],
      option_type_ids: []
    ]
  end

  def spree_shipping_method
    [
      :name,
      :hidden,
      :removed,
      :admin_name,
      :display_on,
      :deleted_at,
      :tracking_url,
      :tax_category_id,
      :processing_time,
      calculator_attributes: nested(self.calculator),
      zones_attributes: nested(self.zone),
      shipping_category_ids: [],
      zone_ids: []
    ]
  end

  def spree_stock_location
    [
      :name,
      :admin_name,
      :address1,
      :address2,
      :city,
      :state_id,
      :state_name,
      :country_id,
      :zipcode,
      :phone,
      :active,
      :backorderable_default,
      :propagate_all_variants,
      stock_items_attributes: nested(self.spree_stock_item)
    ]
  end

  def spree_stock_item
    [
      :variant,
      :backorderable,
      stock_movements_attributes: nested(self.spree_stock_movement)

    ]
  end

  def spree_stock_movement
    [
      :quantity
    ]
  end

  def availability_template
    [
      :transactable_type,
      :name, :description,
      :availability_rules,
      :availability_rules_attributes => nested(self.availability_rule)
    ]
  end

  def text_filter
    [
      :name,
      :regexp,
      :flags,
      :replacement_text
    ]
  end

  def transactable_type
    [
      :name,
      :pricing_options,
      :pricing_validation,
      :availability_options,
      :favourable_pricing_rate,
      :overnight_booking,
      :cancellation_policy_enabled,
      :cancellation_policy_penalty_percentage,
      :cancellation_policy_hours_for_cancellation,
      :enable_cancellation_policy,
      :show_page_enabled,
      :groupable_with_others,
      :service_fee_guest_percent, :service_fee_host_percent,
      :bookable_noun, :lessor, :lessee,
      :availability_templates_attributes => nested(self.availability_template),
      :action_type_ids => []
    ]
  end

  def amenity_type
    [
      :name,
      :amenities_attributes => nested(self.amenity)
    ]
  end

  def location_type
    [
      :name
    ]
  end

  def instance_payment_gateway
    [
      :payment_gateway_id,
      :live_settings,
      :test_settings,
      :country,
      :name,
      :supported_countries
    ]
  end

  def instance_admin_buy_sell_configuration
    [
      :currency,
      :currency_symbol_position,
      :currency_decimal_mark,
      :currency_thousands_separator,
      :infinite_scroll,
      :random_products_for_cross_sell
    ]
  end

  def translation
    [
      :key,
      :instance_id,
      :locale,
      :value
    ]
  end

  def page
    [
      :path,
      :content,
      :css_content,
      :hero_image,
      :slug,
      :position,
      :redirect_url
    ]
  end

  def instance_view
    [
      :body,
      :path,
      :format,
      :handler,
      :transactable_type_id,
      :locale,
      :partial
    ]
  end

  def partner
    [
      :name,
      :search_scope_option,
      :domain_attributes => nested(self.domain),
      :theme_attributes => self.theme
    ]
  end

  def spree_product
    [
      :name,
      :sku,
      :slug,
      :description,
      :price,
      :cost_price,
      :cost_currency,
      :available_on,
      :user_id,
      :weight,
      :height,
      :width,
      :depth,
      :shipping_category_id,
      :tax_category_id,
      :meta_keywords,
      :meta_description,
      :shipping_category_attributes => nested(self.spree_shipping_category),
      option_type_ids: [],
      taxon_ids: []
    ]
  end

  def spree_shipping_category
    [
      :name
    ]
  end

  def theme
    [
      :name,
      :site_name,
      :tagline,
      :meta_title,
      :description,
      :phone_number,
      :contact_email,
      :support_email,
      :address,
      :blog_url,
      :facebook_url,
      :twitter_url,
      :gplus_url,
      :color_blue,
      :color_red,
      :color_orange,
      :color_green,
      :color_gray,
      :color_black,
      :color_white,
      :homepage_css,
      :homepage_content,
      :call_to_action,
      :white_label_enabled,
      :support_url,
      theme_font_attributes: nested(self.theme_font),
    ]
  end

  def theme_font
    [
      :bold_eot, :bold_svg, :bold_ttf, :bold_woff,
      :medium_eot, :medium_svg, :medium_ttf, :medium_woff,
      :regular_eot, :regular_svg, :regular_ttf, :regular_woff
    ]
  end

  def support_faq
    [
      :question,
      :answer
    ]
  end

  def support_ticket
    [
      messages_attributes: support_message
    ]
  end

  def support_ticket_message_attachment
    [
      :file, :tag, :file_cache
    ]
  end

  def guest_support_message
    [
      :message,
      attachment_ids: []
    ]
  end

  def support_message
    [
      :message,
      :subject,
      :full_name,
      :email,
      attachment_ids: [],
    ]
  end

  def user_message
    [
      :body,
      :replying_to_id
    ]
  end

  def inquiry
    [
      :name,
      :company_name,
      :email
    ]
  end

  def company
    [
      :name,
      :url,
      :email,
      :description,
      :mailing_address,
      :paypal_email,
      :bank_owner_name,
      :bank_routing_number,
      :bank_account_number,
      :white_label_enabled,
      :listings_public,
      locations_attributes: nested(self.location),
      domain_attributes: nested(self.domain),
      approval_requests_attributes: nested(self.approval_request),
      company_address_attributes: nested(self.address),
      theme_attributes: self.theme,
      industry_ids: [],
      products_attributes: nested(self.spree_product),
      shipping_categories_attributes: nested(self.spree_shipping_category),
      shipping_methods_attributes: nested(self.spree_shipping_method),
      stock_locations_attributes: nested(self.spree_stock_location)
    ]
  end

  def domain
    [
      :name,
      :target,
      :target_id,
      :target_type,
      :secured,
      :white_label_enabled,
      :google_analytics_tracking_code,
      :certificate_body,
      :private_key,
      :certificate_chain,
      :redirect_to,
      :redirect_code
    ]
  end

  def address
    [
      :address, :address2, :formatted_address, :postcode,
      :suburb, :city, :state, :country, :street,
      :latitude, :local_geocoding, :longitude, :state_code,
      address_components: [:long_name , :short_name, :types]
    ]
  end

  def form_component
    [ :form_type, :name ]
  end

  def location
    [
      :description, :email, :info, :currency,
      :phone, :availability_template_id, :special_notes,
      :location_type_id, :photos,
      :administrator_id, :name, :location_address,
      :availability_template_id,
      availability_rules_attributes: nested(self.availability_rule),
      location_address_attributes: nested(self.address),
      listings_attributes: nested(self.transactable),
      approval_requests_attributes: nested(self.approval_request),
      amenity_ids: [],
      waiver_agreement_template_ids: []
    ] + self.address
  end

  def transactable(transactable_type = nil)
    Transactable::PRICE_TYPES.collect{|t| "#{t}_price".to_sym} +
      [
        :location_id, :availability_template_id,
        :defer_availability_rules, :free,
        :hourly_reservations, :price_type, :draft, :enabled,
        :last_request_photos_sent_at, :activated_at, :rank,
        :transactable_type_id, :transactable_type,
        photos_attributes: nested(self.photo),
        approval_requests_attributes: nested(self.approval_request),
        availability_rules_attributes: nested(self.availability_rule),
        photo_ids: [],
        amenity_ids: [],
        waiver_agreement_template_ids: [],
    ] +
    Transactable.public_custom_attributes_names((transactable_type.presence || PlatformContext.current.try(:instance).try(:transactable_types).try(:first)).try(:id))
  end

  def availability_rule
    [
      :day,
      :close_hour,
      :close_minute,
      :open_hour,
      :open_minute,
      :open_time,
      :close_time,
    ]
  end

  def amenity
    [
      :name,
      :amenity_type_id
    ]
  end

  def admin_approval_request
    [
      :state, :notes, :state_event
    ]
  end

  def approval_request
    [
      :message, :approval_request_template_id,
      approval_request_attachments_attributes: nested(self.approval_request_attachment)
    ]
  end

  def approval_request_template
    [
      :owner_type, :required_written_verification,
      approval_request_attachment_templates_attributes: nested(self.approval_request_attachment_template)
    ]
  end

  def approval_request_attachment_template
    [
      :label, :hint, :required
    ]
  end

  def approval_request_attachment
    [
      :approval_request_attachment_template_id,
      :caption,
      :file,
      :file_cache,
    ]
  end

  def photo
    [
      :image,
      :caption,
      :position
    ]
  end

  def user
    [
      :name, :email, :phone, :job_title, :password, :avatar,
      :avatar_versions_generated_at, :avatar_transformation_data,
      :biography, :country_name, :mobile_number,
      :facebook_url, :twitter_url, :linkedin_url, :instagram_url,
      :current_location, :company_name, :skills_and_interests,
      :sms_notifications_enabled, :time_zone,
      :country_name_required, :skip_password,
      :country_name, :phone, :mobile_phone,
      :first_name, :middle_name, :last_name, :gender,
      :drivers_licence_number, :gov_number, :twitter_url,
      :linkedin_url, :facebook_url, :google_plus_url,
      industry_ids: [],
      companies_attributes: nested(self.company),
      approval_requests_attributes: nested(self.approval_request),
      user_instance_profiles_attributes: nested(self.user_instance_profiles)
    ]
  end

  def user_instance_profiles
    UserInstanceProfile.public_custom_attributes_names(InstanceProfileType.first.try(:id))
  end

  def workflow
    [
      :name
    ]
  end

  def workflow_step()
    [:name]
  end

  def workflow_alert(step_associated_class = nil)
    [
      :name,
      :alert_type,
      :recipient_type,
      :recipient,
      :template_path,
      :delay,
      :from,
      :from_type,
      :reply_to,
      :replt_to_type,
      :cc,
      :bcc,
      :subject,
      :layout_path
    ] + (step_associated_class.present? && defined?(step_associated_class.constantize::CUSTOM_OPTIONS) ? [custom_options: step_associated_class.constantize::CUSTOM_OPTIONS] : [])
  end

  def waiver_agreement_template
    [
      :content,
      :name
    ]
  end

  def waiver_agreement
    []
  end


  def nested(object)
    object + [:id, :_destroy]
  end

  def rating_systems
    [
      rating_systems: self.rating_system
    ]
  end

  def rating_system
    [
      :subject,
      :active,
      :transactable_type_id,
      rating_hints_attributes: self.rating_hint,
      rating_questions_attributes: self.nested(rating_question)
    ]
  end

  def rating_hint
    [
      :id,
      :description
    ]
  end

  def rating_question
    [
      :text,
    ]
  end

  def review
    [
      :rating, 
      :comment, 
      :object, 
      :date, 
      :transactable_type_id, 
      :reviewable_id, 
      :reviewable_type, 
      :user_id
    ]
  end

  def rating_answers
    [
      rating_answers: self.rating_answer
    ]
  end

  def rating_answer
    [
      :id,
      :rating,
      :rating_question_id
    ]
  end
end
