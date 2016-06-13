class MarketplaceSessionsController < ApplicationController
  layout 'password_protected'

  skip_before_filter :redirect_if_marketplace_password_protected

  def new
  end

  def create
    if platform_context.instance.authenticate(params[:password])
      session["authenticated_in_marketplace_#{platform_context.instance.id}".to_sym] = true
      redirect_url = session[:marketplace_return_to] || root_path
      session[:marketplace_return_to] = nil
      redirect_to redirect_url
    else
      flash.now[:error] = t('flash_messages.marketplace_sessions.wrong_password')
      render :new
    end
  end
end
