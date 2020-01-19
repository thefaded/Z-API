class UserMailer < ApplicationMailer
  def welcome_employee(user_id, reset_password_token = nil)
    @user = User.find_by(id: user_id)
    @reset_password_token = reset_password_token
    return if @user.blank?

    mail(to: @user.email, subject: 'Welcome to Z-API')
  end
end
