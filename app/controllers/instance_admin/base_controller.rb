class InstanceAdmin::BaseController < ApplicationController
  layout 'instance_admin'

  before_filter :auth_user!
  before_filter :authorize_user!
  before_filter :check_if_locked, only: [:new, :create, :edit, :update, :destroy]
  before_filter :force_scope_to_instance
  skip_before_filter :redirect_if_marketplace_password_protected

  ANALYTICS_CONTROLLERS = {
    'overview' => { default_action: 'show' }
  }

  MANAGE_CONTROLLERS = {
    'approval_requests' => { controller: '/instance_admin/manage/approval_requests', default_action: 'index' },
    'inventories' => { controller: '/instance_admin/manage/inventories', default_action: 'index' },
    'transfers'   => { controller: '/instance_admin/manage/transfers', default_action: 'index' },
    'partners'    => { controller: '/instance_admin/manage/partners', default_action: 'index' },
    'users'       => { controller: '/instance_admin/manage/users', default_action: 'index' },
    'emails' => { controller: '/instance_admin/manage/email_templates', default_action: 'index' },
    'waiver_agreements' => { controller: '/instance_admin/manage/waiver_agreement_templates', default_action: 'index' },
    'custom_attributes' => { controller: '/instance_admin/manage/instance_profile_types', default_action: 'index' },
    'transactable_types' => { controller: '/instance_admin/manage/transactable_types', default_action: 'index' },
    'support' => { controller: '/instance_admin/manage/support', default_action: 'index' },
    'faq' => { controller: '/instance_admin/manage/support/faqs', default_action: 'index' }
  }

  MANAGE_BLOG_CONTROLLERS = {
    'posts' => { default_action: 'index' },
    'settings'   => { default_action: 'edit' }
  }

  SETTINGS_CONTROLLERS = {
    'configuration' => { default_action: 'show' },
    'domains'       => { default_action: 'index' },
    'locations'     => { default_action: 'show' },
    'listings'      => { default_action: 'show' },
    'translations'  => { default_action: 'show' },
    'integrations'  => { default_action: 'show' },
    'cancellation_policy'  => { default_action: 'show' },
  }

  THEME_CONTROLLERS = {
    'info'     => { default_action: 'show' },
    'design'   => { default_action: 'show' },
    'footer'   => { default_action: 'show' },
    'homepage' => { controller: '/instance_admin/theme/homepage_template', default_action: 'show' },
    'homepage content' => { controller: '/instance_admin/theme/homepage', default_action: 'show' },
    'pages'    => { default_action: 'index' }
  }

  BUY_SELL_CONTROLLERS = {
    'configuration' => { default_action: 'show' },
    'commissions' => { default_action: 'show' },
    'tax_categories' => { default_action: 'index' },
    'tax_rates' => { default_action: 'index' },
    'zones' => { default_action: 'index' },
    'taxonomies' => { default_action: 'index' },
    'shipping_categories' => { default_action: 'index' },
    'shipping_methods' => { default_action: 'index' },
  }

  def index
    redirect_to url_for([:instance_admin, @authorizer.first_permission_have_access_to])
  end

  private

  def check_if_locked
    if PlatformContext.current.instance.locked?
      flash[:notice] = 'You have been redirected because instance is locked, no changes are permitted. All changes have been discarded. You can turn off Master Lock here.'
      redirect_to url_for([:instance_admin, :settings, :configuration])
    end
  end

  def auth_user!
    unless user_signed_in?
      session[:user_return_to] = request.path
      redirect_to instance_admin_login_path
    end
  end

  def authorize_user!
    @authorizer ||= InstanceAdminAuthorizer.new(current_user)
    if !(@authorizer.instance_admin?)
      flash[:warning] = t('flash_messages.authorizations.not_authorized')
      redirect_to root_path
    elsif !@authorizer.authorized?(permitting_controller_class)
      first_permission_have_access_to = @authorizer.first_permission_have_access_to
      if first_permission_have_access_to
        flash[:warning] = t('flash_messages.authorizations.not_authorized')
        redirect_to url_for([:instance_admin, first_permission_have_access_to])
      else
        redirect_to root_path
      end
    end
  rescue InstanceAdminAuthorizer::UnassignedInstanceAdminRoleError => e
    ExceptionTracker.track_exception(e)
    flash[:warning] = t('flash_messages.authorizations.not_authorized')
    redirect_to root_path
  end

  def permitting_controller_class
    self.class.to_s.deconstantize.demodulize
  end

  def instance_admin_roles
    @instance_admin_roles ||= InstanceAdminRole.all
  end
  helper_method :instance_admin_roles

end
