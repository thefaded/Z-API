module Authenticatable
  extend ActiveSupport::Concern

  def authenticate_user!
    request.env['warden'].authenticate!(:jwt)
  end

  def authenticate_terminal!
    request.env['warden'].authenticate!(:basic_auth_terminal)
  end

  def current_user
    request.env['warden'].user
  end

  def current_terminal
    request.env['warden'].user
  end
end
