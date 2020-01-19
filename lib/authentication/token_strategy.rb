require 'warden'

module Authentication
  class TokenStrategy < Warden::Strategies::Base
    def valid?
      access_token.present?
    end

    def authenticate!
      user = User.find_by(token: access_token)

      fail('') if user.blank?

      user.regenerate_token
      success!(user)
    end

    private

    def access_token
      @access_token ||= request.get_header('access_token')
    end
  end
end
