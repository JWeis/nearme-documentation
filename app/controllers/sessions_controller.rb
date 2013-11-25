class SessionsController < Devise::SessionsController
  skip_before_filter :redirect_to_set_password_unless_unnecessary, :only => [:destroy]
  before_filter :set_return_to
  skip_before_filter :require_no_authentication, :only => [:show] , :if => lambda {|c| request.xhr? }
  after_filter :render_or_redirect_after_create, :only => [:create] 
  before_filter :set_layout

  def new
    super unless already_signed_in?
    # populate errors but only if someone tried to submit form
    if !current_user && params[:user] && params[:user][:email] && params[:user][:password]
      render_view_with_errors
    end
  end

  def create
    super

    if current_user
      current_user.remember_me!
      update_analytics_google_id(current_user)
      analytics_apply_user(current_user)
      event_tracker.logged_in(current_user, provider: Auth::Omni.new(session[:omniauth]).provider)
    end
  end

  def store_correct_ip
    session[:current_ip] = params[:ip]
    render :nothing => true
  end

  private

  def set_return_to
    session[:user_return_to] = params[:return_to] if params[:return_to].present?
  end

  def set_layout
    if login_from_instance_admin?
      self.class.layout 'instance_admin'
    end
  end

  def render_view_with_errors
    flash[:alert] = nil
    self.response_body = nil
    self.resource.email = params[:user][:email]
    if User.find_by_email(params[:user][:email])
      self.resource.errors.add(:password, 'incorrect password')
    else
      self.resource.errors.add(:email, 'incorrect email')
    end
    render :template => login_from_instance_admin? ? "instance_admin/sessions/new" : "sessions/new"
  end

  def login_from_instance_admin?
    session[:user_return_to] && session[:user_return_to].include?('instance_admin')
  end

  # if ajax call has been made from modal and user has been created, we need to tell 
  # Modal that instead of rendering content in modal, it needs to redirect to new page
  def render_or_redirect_after_create
    if request.xhr? && current_user
      render_redirect_url_as_json
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    (request.referrer && request.referrer.include?('instance_admin')) ? instance_admin_login_path : root_path
  end

end

