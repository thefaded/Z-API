module Authentication
  module Jwt
    class Engine
      class << self
        def encoded_token(payload)
          JWT.encode(payload, secret)
        end

        def decoded_token(token)
          JWT.decode(token, secret)[0]
        end

        def secret
          Rails.application.secrets.secret_key_base
        end
      end
    end
  end
end
