class User < ActiveRecord::Base
  # Authlogic
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
    c.ignore_blank_passwords = false
    c.disable_perishable_token_maintenance = true
  end

  # Gravtastic
  include Gravtastic
  gravtastic default: "mm", rating: "G"

  # Callbacks
  before_save :reset_perishable_token, if: :update_perishable_token?

  # Validations
  validates :login, format: { with: /\A[a-zA-Z0-9_]{3,15}\z/,
    message: I18n.t("activerecord.validations.user.login.invalid_format") }

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver_now
  end

  private

  def update_perishable_token?
    changed? && changed_attributes.keys != ["last_request_at"]
  end
end
