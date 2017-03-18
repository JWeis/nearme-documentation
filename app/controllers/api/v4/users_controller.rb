# frozen_string_literal: true
module Api
  module V4
    class UsersController < Api::V4::BaseController
      skip_before_action :require_authentication, except: [:edit, :update, :destroy]
      skip_before_action :require_authorization
      skip_before_action :redirect_unverified_user, only: [:verify]
      before_action :build_signup_form, only: [:new, :create]
      before_action :build_update_form, only: [:edit, :update]
      before_action :find_user, only: [:verify]
      before_action :build_verification_form, only: [:verify]
      before_action :set_return_to, only: :new

      def new
        @user_signup.prepopulate!
      end

      def create
        if @user_signup.validate(params[:form].presence || params[:user] || {})
          @user_signup.save
          # tmp safety check - we still have validation in User model itself
          # so if model is invalid, it won't be saved and user won't be able to
          # sign up - we want to be notified
          raise "Sign up failed due to configuration issue: #{@user_signup.model.errors.full_messages.join(', ')}" unless @user_signup.model.persisted?
          sign_in(@user_signup.model)
        end
        respond(@user_signup, notice: I18n.t('devise.registrations.signed_up'),
                              alert: false,
                              location: session.delete(:user_return_to).presence || params[:return_to].presence || root_path)
      end

      def update
        if @user_update_form.validate(params[:form].presence || params[:user] || {})
          @user_update_form.save
          I18n.locale = current_user.reload.language&.to_sym || :en
          # tmp safety check - we still have validation in User model itself
          # so if model is invalid, it won't be saved and user won't be able to
          # sign up - we want to be notified
          raise "Update failed due to configuration issue: #{@user_update_form.model.errors.full_messages.join(', ')}" if @user_update_form.errors.any?
        end
        respond(@user_update_form, notice: I18n.t('flash_messages.api.users.update.notice'),
                                   alert: false)
      end

      def verify
        if @verification_form.validate(params)
          @verification_form.save
          sign_in(@verification_form.model)
          flash[:success] = t('flash_messages.registrations.address_verified')
          redirect_to root_path
        else
          flash[:error] = @verification_form.errors.full_messages.join(', ')
          respond(@verification_form)
        end
      end

      protected

      def build_signup_form
        @form_configuration = FormConfiguration.find_by(id: params[:form_configuration_id]) if params[:form_configuration_id].present?
        @user_signup = @form_configuration&.build(new_user) || FormBuilder::UserSignupBuilderFactory.builder(params[:role]).build(new_user)
      end

      def build_update_form
        @form_configuration = FormConfiguration.find(params[:form_configuration_id])
        @user_update_form = @form_configuration&.build(current_user)
      end

      def new_user
        ::User.new_with_session({}, session)
      end

      def build_verification_form
        @verification_form = UserVerificationForm.new(@user, verified_at: @user.verified_at)
      end

      def find_user
        @user = User.find(params[:id])
      end

      def set_return_to
        disallowed_regex = /(users\/sign_in|users\/password)/
        if params[:return_to].present? && !params[:return_to].to_s.match(disallowed_regex)
          session[:user_return_to] = params[:return_to]
        end
      end
    end
  end
end