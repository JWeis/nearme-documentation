module ApplicationHelper

  include FormHelper
  include TooltipHelper
  include CurrencyHelper
  include FileuploadHelper
  include SharingHelper
  include CustomAttributes::ApplicationHelper

  def timeago(time)
    content_tag(:abbr, time, title: time.to_time.iso8601, class: :timeago)
  end

  def platform_context
    @platform_context_view ||= PlatformContext.current.decorate
  end

  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def canonical_url(url)
    content_for(:canonical_url) { url }
  end

  def meta_title(name)
    content_for(:meta_title) { h(name.to_s) }
  end

  def title_tag
    (show_title? ? content_for(:title) : platform_context.tagline.to_s) +
      (additional_meta_title.presence ? " | " + additional_meta_title : '')
  end

  def meta_description(description)
    content_for(:meta_description) { h(description.to_s) }
  end

  def meta_description_content
    content_for?(:meta_description) ? content_for(:meta_description) : (platform_context.description || platform_context.name)
  end

  def additional_meta_title
    content_for?(:meta_title) ? content_for(:meta_title) : platform_context.meta_title
  end

  def show_title?
    @show_title
  end

  def apply_analytics?
    # Enable mixpanel in all environments. We use a different account for
    # production.
    true
  end

  def truncate_with_ellipsis(body, length, html_options = {})

    body ||= ''
    if body.size > length

      size = 0
      body = body.squish

      truncated_body = body.split.reject do |token|
        size += token.size + 1
        size > length
      end

      truncated_body_str = truncated_body.join(' ')
      truncated_body_regexp = Regexp.new("^#{Regexp.escape(truncated_body_str)}")
      excess_body = body.gsub(truncated_body_regexp, '').strip

      content_tag(:p, html_options) do
        truncated_body_str.html_safe +
        content_tag(:span, "&hellip;".html_safe, :class => 'truncated-ellipsis').html_safe +
        content_tag(:span, excess_body.html_safe, :class => 'truncated-text hidden').html_safe
      end

    else
      body
    end

  end

  def link_to_registration(constraint, secured_constraint, secure_links, options = {}, &block)
    options[:rel] = nil if secure_links
    constraint.merge!(secured_constraint) if secure_links
    options[:data] ||= {}
    options[:data].merge!({ href: new_user_registration_url(constraint) })
    link_to('#', options, &block)
  end

  def link_to_login(constraint, secured_constraint, secure_links, options = {}, &block)
    options[:rel] = nil if secure_links
    constraint.merge!(secured_constraint) if secure_links
    options[:data] ||= {}
    options[:data].merge!({ href: new_user_session_url(constraint) })
    link_to('#', options, &block)
  end

  def get_return_to_url
    in_signed_in_or_sign_up? ? {} : {:return_to => "#{request.protocol}#{request.host_with_port}#{request.fullpath}"}
  end

  def in_signed_in_or_sign_up?
    in_signed_in? || in_sign_up?
  end

  def in_signed_in?
    params[:controller]=='sessions'
  end

  def in_sign_up?
    params[:controller]=='registrations'
  end

  def link_to_once(*args, &block)
    options = args.first || {}
    html_options = args.second || {}

    unless html_options.key?(:disable_with) then html_options[:disable_with] = "Loading..." end
    if block_given?
      link_to(capture(&block), options, html_options)
    else
      link_to(options, html_options)
    end
  end

  def ico_for_flash(key)
    case key.to_s
    when 'notice'
      "ico-check"
    when 'success'
      "ico-check"
    when 'error'
      "ico-warning"
    when 'warning'
      "ico-warning"
    when 'deleted'
      "ico-close"
    end
  end

  def flash_key_name(key)
    case key.to_s
    when 'deleted'
      'warning'
    when 'error'
      'danger'
    when 'notice'
      'info'
    else
      key
    end
  end

  def array_to_unordered_list(arr = [])
    arr.map{|s| "<li>#{s}</li>"}.join.tap{|s| "<ul>#{s}</ul>"}
  end

  def section_class(section_name = nil)
    [
      section_name,
      controller_name,
      "#{controller_name}-#{params[:action]}"
    ].compact.join(' ')
  end

  def theme_class(theme_name = nil)
    [
      theme_name,
      controller_name,
      "#{controller_name}-#{params[:action]}",
    ].compact.join(' ')
  end


  def dnm_page_class
    [(content_for?(:top_sub_navigation) ? 'with-sub-navbar' : nil), (no_navbar? ? 'no-navbar' : nil)].compact.join(' ')
  end

  def distance_of_time_in_words_or_date(datetime)
    today = Date.current

    case datetime
    when DateTime, ActiveSupport::TimeWithZone, Time
      if datetime.to_date == today
        datetime.strftime("%l:%M%P")
      elsif datetime.to_date == today.yesterday
        'Yesterday'
      elsif datetime > (today - 7.days)
        datetime.strftime("%A")
      else
        datetime.strftime("%Y-%m-%d")
      end
    else
      ''
    end
  end

  def distance_of_time_in_words_or_date_in_time_zone(datetime, time_zone = 'UTC')
    Time.zone = time_zone
    result = distance_of_time_in_words_or_date(datetime.in_time_zone(time_zone))
    Time.zone = 'UTC'
    result
  end

  def render_olark?
    not params[:controller] == 'locations' && params[:action] == 'show'
  end

  def nl2br(str)
    str.to_s.gsub(/\r\n|\r|\n/, "<br />").html_safe
  end

  def home_page?
    # the first condition has been added because /en [ where en was default language ] was returning true,
    # however /da was returning false, even though it was home page as well. This was causing issues with
    # homepage content / homepage css etc. The second condition is there just in case it was fixing other issue.
    # Btw: adding language: I18n.locale to second condition does not work :)
    params[:controller] == 'home' && params[:action] == 'index' || current_page?(controller: 'home', action: 'index')
  rescue
    false
  end

  def mask_phone_and_email_if_necessary(text)
    if PlatformContext.current.instance.apply_text_filters && text.present?
      @text_filters ||= TextFilter.pluck(:regexp, :replacement_text, :flags)
      @text_filters.each { |text_filter| text.gsub!(Regexp.new(text_filter[0].try(:strip), text_filter[2]), text_filter[1]) }
      text
    else
      text
    end
  end

  def custom_sanitze(html)
    if PlatformContext.current.instance.custom_sanitize_config.present?
      @custom_sanitizer ||= CustomSanitizer.new(PlatformContext.current.instance.custom_sanitize_config)
      @custom_sanitizer.sanitize(html).html_safe
    else
      html
    end
  end

  def orders_navigation_link(state)
    link_to(content_tag(:span, state.titleize), orders_path(state: state),
      class: [
        'upcoming-reservations',
        'btn btn-medium',
        "btn-gray#{state==(params[:state] || 'new') ? " active" : "-darker"}"
      ]).html_safe
  end

  def user_menu_instance_admin_path(users_instance_admin)
    users_instance_admin = 'manage_blog' if users_instance_admin == 'blog'
    main_app.send("instance_admin_#{users_instance_admin}_path")
  end

  def will_paginate_styled(collection, options = {})
    content_tag :div, class: 'pagination' do
      options[:renderer] = BuySellMarket::WillPaginateLinkRenderer::LinkRenderer
      options[:class] = ''
      will_paginate collection, options
    end
  end

  def active_class(arg1, arg2)
    'active' if arg1 == arg2
  end

  def hide_tab?(tab)
    key = "#{params[:controller]}/#{params[:action]}##{tab}"
    HiddenUiControls.find(key).hidden?
  end

  def admin_breadcrumbs
    @breadcrumbs_title.presence || controller.class.to_s.deconstantize.demodulize
  end

  def credit_card_date
    months = (1..12).map do |m|
      m.to_s.rjust(2, '0')
    end

    years = (Time.zone.now.year..(Time.zone.now + 15.years).year)
    {month: months, year: years}
  end

  # This is needed because the extra fields need to be placed in a container
  def should_display_checkout_extra_fields?(user, show_company_name = false)
    if user.field_blank_or_changed?(:country_name) || user.field_blank_or_changed?(:mobile_number) ||
      user.field_blank_or_changed?(:first_name) || user.field_blank_or_changed?(:last_name) ||
      user.field_blank_or_changed?(:phone) || (show_company_name && user.field_blank_or_changed?(:company_name))
      return true
    end

    (user.instance_profile_type.try(:custom_attributes) || []).each do |attribute|
      if attribute.public? && user.field_blank_or_changed?(attribute.name) && ::CustomAttributes::CustomAttribute::FormElementDecorator.new(attribute).options[:required]
        return true
      end
    end

    if ar = user.current_approval_requests.first
      if ar.approval_request_template.required_written_verification && ar.message.blank?
        return true
      end

      ar.approval_request_template.approval_request_attachment_templates.each do |attachment_template|
        next if !attachment_template.required?
        attachment = user.approval_request_attachments.for_request_or_free(ar.id).for_attachment_template(attachment_template.id).first
        return true if attachment.nil?
      end
    end

    false
  end

  def selected_date_value(date)
    Review::DATE_VALUES.each do |value|
      return I18n.t("instance_admin.manage.admin_searchable.#{value}") if value == date
    end
    date
  end

  def cache_expires_in_for(cache_model = '')
    Rails.configuration.default_cache_expires_in
  end

  def is_i18n_set?(key)
    I18n.t(key, default: '').present?
  end

end
