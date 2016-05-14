require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    login: Field::String,
    email: Field::String,
    first_name: Field::String,
    last_name: Field::String,
    crypted_password: Field::String,
    password_salt: Field::String,
    persistence_token: Field::String,
    perishable_token: Field::String,
    login_count: Field::Number,
    failed_login_count: Field::Number,
    last_request_at: Field::DateTime,
    current_login_at: Field::DateTime,
    last_login_at: Field::DateTime,
    current_login_ip: Field::String,
    last_login_ip: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    role: Field::Select.with_options(collection: User.roles.keys),
    identification: Field::Select.with_options(collection: User.identifications.keys),
    identified_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  COLLECTION_ATTRIBUTES = [
    :id,
    :role,
    :login,
    :email,
    :identification,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :login,
    :email,
    :first_name,
    :last_name,
    :crypted_password,
    :password_salt,
    :persistence_token,
    :perishable_token,
    :login_count,
    :failed_login_count,
    :last_request_at,
    :current_login_at,
    :last_login_at,
    :current_login_ip,
    :last_login_ip,
    :created_at,
    :updated_at,
    :role,
    :identification,
    :identified_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :login,
    :email,
    :first_name,
    :last_name,
    :role,
    :identification,
  ].freeze

  # How users are displayed across all pages of the admin dashboard.
  def display_resource(user)
    "User ##{user.id} (#{user.name})"
  end
end
