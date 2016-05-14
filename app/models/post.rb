class Post < ActiveRecord::Base
  include AASM

  ## ASSOCIATIONS

  belongs_to :user

  ## VALIDATIONS

  validates :user,  presence: true
  validates :title, presence: true
  validates :body,  presence: true
  validates :state, inclusion: { in: %w(draft in_review published unpublished deleted) }

  ## SCOPES

  scope :owned_by, ->(user) { where(user: user) }

  # ENUMS

  enum state: {
    draft: 0,
    in_review: 1,
    published: 2,
    unpublished: 3,
    deleted: 99
  }

  ## MACHINE STATES

  aasm column: :state, enum: true do
    state :draft, initial: true
    state :in_review
    state :published
    state :unpublished
    state :deleted

    event :submit do
      transitions from: :draft, to: :in_review
    end

    event :publish do
      transitions from: [:draft, :in_review], to: :published
    end

    event :unpublish do
      transitions from: :published, to: :unpublished
    end

    event :delete do
      transitions from: [:draft, :in_review, :published, :unpublished], to: :deleted
    end

    event :recover do
      transitions from: :deleted, to: :draft
    end
  end

  # METHODS

  def preview_mode?
    draft? || in_review? || unpublished?
  end
end
