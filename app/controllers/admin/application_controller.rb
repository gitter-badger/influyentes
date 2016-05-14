module Admin
  class ApplicationController < Administrate::ApplicationController
    before_filter :authenticate_admin

    helper_method :user_session, :current_user, :admin_signed_in?

    private

    # Session of current signed in user
    def user_session
      @user_session ||= UserSession.find
    end

    # Current signed in user
    def current_user
      @current_user ||= user_session && user_session.user
    end

    # Checks whether there is a admin signed in or not
    def admin_signed_in?
      current_user.try(:administrator?)
    end

    def authenticate_admin
      unless admin_signed_in?
        flash[:error] = "You not have access."
        redirect_to(root_path)
      end
    end
  end
end
