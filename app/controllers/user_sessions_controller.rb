class UserSessionsController < ApplicationController
  before_filter :user_cannot_be_logged_in!, only: [:new, :create]

  # GET /login
  def new
    @user = User.new
  end

  # POST /login
  def create
    @user_session = UserSession.new(user_session_params)

    if @user_session.save
      flash[:notice] = I18n.t("users.session.messages.logged_in")
      redirect_to root_path
    else
      flash[:notice] = I18n.t("users.session.messages.error_logged_in")
      redirect_to login_path
    end
  end

  # GET /logout
  def destroy
    if user_signed_in?
      user_session.destroy
      flash[:notice] = I18n.t("users.session.messages.logged_out")
    end

    redirect_to login_path
  end

  private

  def user_session_params
    params.require(:user).permit(:login, :password)
  end

  def user_cannot_be_logged_in!
    if user_signed_in?
      flash[:error] = t "user_policy.login?", scope: "pundit", default: :default
      redirect_to(request.referrer || root_path)
      return false
    end
  end
end
