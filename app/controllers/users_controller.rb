class UsersController < ApplicationController
  before_filter :user_cannot_be_logged_in!, only: [:new, :create]
  before_filter :set_user_using_perishable_token, only: [:password_reset]
  before_filter :set_user, except: [:new, :create, :password, :password_reset]

  # GET /signup
  def new
    @user = User.new
  end

  # POST /signup
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = I18n.t("users.new.messages.signed_up_success")
      redirect_to root_path
    else
      render action: :new
    end
  end

  # GET /users/1
  def show
    authorize @user
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # PUT /users/1/edit
  def update
    authorize @user

    if @user.update_attributes(user_params)
      flash[:notice] = I18n.t("users.new.messages.updated_success")
      redirect_to users_path
    else
      render action: :edit
    end
  end

  # GET & POST /users/password
  def password
    @user = User.new

    if request.post?
      @user = User.find_by_email(user_params[:email])

      if @user
        @user.deliver_password_reset_instructions!
        flash[:notice] = "Instructions to reset your password have been emailed to you. " +
          "Please check your email."
        redirect_to root_path
      else
        @user = User.new
        flash[:notice] = "No user was found with that email address"
      end
    end
  end

  # GET & PATCH /users/password/reset
  def password_reset
    @user ||= User.new

    if request.patch?
      @user.password = user_params[:password]
      @user.password_confirmation = user_params[:password_confirmation]

      if @user.save
        flash[:notice] = "Password successfully updated"
        redirect_to root_path
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:login, :email, :password, :password_confirmation, :token)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_user_using_perishable_token
    @token = params[:token].presence || params[:user][:token].presence
    @user  = User.find_using_perishable_token(@token)

    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account." +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to root_path
    end
  end

  def user_cannot_be_logged_in!
    if user_signed_in?
      flash[:error] = t "user_policy.new?", scope: "pundit", default: :default
      redirect_to(request.referrer || root_path)
      return false
    end
  end
end
