class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Custom error messages
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :user_session, :current_user, :user_signed_in?,
    :allowed_to_access_administration_panel?

  private

  # Session of current signed in user
  def user_session
    @user_session ||= UserSession.find
  end

  # Current signed in user
  def current_user
    @current_user ||= user_session && user_session.user
  end

  # Checks whether there is a user signed in or not
  def user_signed_in?
    current_user.present?
  end

  def authenticate_user
    unless user_signed_in?
      flash[:error] = "You need to log in or sign up before continuing."
      redirect_to(request.referrer || root_path)
    end
  end

  # Create a flash error for pundit authoritzations and redirect
  def user_not_authorized(exception)
    if exception.is_a? String
      flash[:error] = t "#{exception}", scope: "pundit", default: :default
    else
      policy_name = exception.policy.class.to_s.underscore
      flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    end

    redirect_to(request.referrer || root_path)
  end
end
