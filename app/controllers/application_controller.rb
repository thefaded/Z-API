class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate_user_for_admin_panel!
    authenticate_user!

    return if current_user.admin?

    sign_out(current_user)
    flash['notice'] = 'Invalid Email or password.'
    redirect_to admin_root_path
  end
end
