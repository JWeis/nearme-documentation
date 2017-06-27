# frozen_string_literal: true
class Authorize
  def initialize(user:, object: nil, params: {})
    @user = user
    @object = object
    @params = params
  end

  def call
    return true unless @object
    return true unless unauthorized_policy
    raise UnauthorizedAction, unauthorized_policy: unauthorized_policy, user: @user,
                              object: @object, params: @params
  end

  protected

  def unauthorized_policy
    @unathorized_policy ||= @object.authorization_policies.detect do |authorization_policy|
      AuthorizationPolicy::PolicyAuthorizer.unauthorized?(
        AuthorizationPolicy::EvaluatedPolicy.new(user: @user,
                                                 object: @object,
                                                 params: ::LiquidView.sanitize_params(@params),
                                                 policy: authorization_policy.content)
      )
    end
  end

  class UnauthorizedAction < StandardError
    attr_reader :unauthorized_policy, :user, :object, :params
    def initialize(unauthorized_policy:, user:, object:, params:)
      @unauthorized_policy = unauthorized_policy
      @user = user
      @object = object
      @params = params
    end
  end
end