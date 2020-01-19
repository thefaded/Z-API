require 'warden'

module Authentication
  module Strategies
    class JwtTokenStrategy < Warden::Strategies::Base
      # Method for `Authorization` header
      # Token is present in request/response headers
      # as `Bearer %token%`
      METHOD = 'Bearer'.freeze

      def valid?
        token.present?
      end

      def store?
        false
      end

      def authenticate!
        payload = decoded_token
        user = User.find_by(id: payload['user_id'])
        success!(user)
      rescue JWT::ExpiredSignature
        @status = 401
        fail!('Token has expired')
      rescue JWT::DecodeError => e
        fail!(e.message)
      end

      private

      def token
        @token ||= token_from_authorization_header
      end

      # Parses token from Rack request
      def token_from_authorization_header
        auth = env['HTTP_AUTHORIZATION']
        return nil unless auth

        method, token = auth.split
        method == METHOD ? token : nil
      end

      def decoded_token
        Authentication::Jwt::Engine.decoded_token(token_from_authorization_header)
      end

      def secret
        Rails.application.credentials.secret_key_base.to_s
      end
    end
  end
end
