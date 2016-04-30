class Notifier < ActionMailer::Base
  default_url_options[:host] = "localhost:3000"
  default from: "notifications@example.com"

  # def password_reset_instructions(user)
  #   subject       "Password Reset Instructions"
  #   from          "Binary Logic Notifier <noreply@binarylogic.com>"
  #   recipients    user.email
  #   sent_on       Time.now
  #   body          :edit_password_reset_url => edit_password_reset_url(token: user.perishable_token)
  # end

  def password_reset_instructions(user)
    @user = user
    @url  = password_reset_users_url(token: @user.perishable_token)
    mail(to: @user.email, subject: "Password Reset Instructions")
  end
end
