# frozen_string_literal: true
class UserVerificationForm < BaseForm

  # @!attribute token
  #   @return [String] token string to identify the user
  property :token, virtual: true

  # @!attribute verified_at
  #   @return [DateTime] when the user was verified
  property :verified_at, virtual: true

  validate :token do
    errors.add(:token, :blank) if token.blank?
    errors.add(:token, :invalid) if token_invalid?
  end

  def email_verification_token
    Digest::SHA1.hexdigest(
      "--dnm-token-#{model.id}-#{model.created_at.utc.strftime('%Y-%m-%d %H:%M:%S')}"
    )
  end

  def sync
    super
    model.verified_at = Time.zone.now if model.verified_at.blank?
    true
  end

  protected

  def token_invalid?
    email_verification_token != token
  end
end