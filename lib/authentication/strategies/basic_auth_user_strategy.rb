require 'warden'
require 'rack/auth/basic'

module Authentication
  module Strategies
    class BasicAuthUserStrategy < Warden::Strategies::Base
      def valid?
        request.provided? && request.basic? && request.credentials
      end

      def store?
        false
      end

      def authenticate!
        user = authenticate_user(email, password)

        if user
          authentication_successful(user)
        else
          authentication_failed
        end
      end

      def authenticate_user(email)
        User.find_by(email: email)
      end

      def authentication_successful(user)
        success!(user)
      end

      def authentication_failed
        headers('WWW-Authenticate' => %(#{auth_scheme} realm="#{realm}"))

        fail!('Unauthorized')
      end

      def request
        @request ||= Rack::Auth::Basic::Request.new(env)
      end

      def email
        request.credentials[0]
      end

      def password
        request.credentials[1]
      end

      def auth_scheme
        'Basic'
      end

      def realm
        'private area'
      end
    end
  end
end
