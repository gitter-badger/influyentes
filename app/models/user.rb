class User < ActiveRecord::Base
  include AASM
  include Gravtastic

  # Authlogic
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
    c.ignore_blank_passwords = false
    c.disable_perishable_token_maintenance = true
    c.validates_length_of_password_field_options = { minimum: 6, if: :require_password? }
  end

  # Gravtastic
  gravtastic default: "mm", rating: "G"

  ## CALLBACKS

  before_save :reset_perishable_token, if: :update_perishable_token?

  ## VALIDATIONS

  validates :role, inclusion: { in: %w(user reviewer moderator administrator banned deleted) }
  validates :identification, inclusion: { in: %w(unidentified identified) }

  ## ENUMES

  enum role: {
    user: 0,
    reviewer: 2,
    moderator: 3,
    administrator: 4,
    banned: 90,
    deleted: 99
  }

  enum identification: {
    unidentified: 0,
    identified: 1
  }

  ## MACHINE STATES

  aasm column: :identification, enum: true do
    state :unidentified, initial: true
    state :identified

    event :identify do
      after { self.identified_at = Time.now.to_i }
      transitions from: :unidentified, to: :identified
    end

    event :unidentify do
      after { self.identified_at = nil }
      transitions from: :identified, to: :unidentified
    end
  end

  ## METHODS

  def name
    first_name.presence || login.presence
  end

  ## PERMISSIONS METHODS

  # Permission review
  def can_review?
    reviewer? || moderator? || administrator?
  end

  # Permission publish
  def can_publish?
    reviewer? || moderator? || administrator?
  end

  # Permission unpublish
  def can_unpublish?
    moderator? || administrator?
  end

  # Permission delete
  def can_delete?
    administrator?
  end

  ## DELIVER METHODS

  # Deliver email with password reset instructions
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver_now
  end

  # Deliver email with confirmation email instructions
  def deliver_confirmation_email_instructions!
    # TODO
  end

  private

  def update_perishable_token?
    changed? && changed_attributes.keys != ["last_request_at"]
  end
end
