require 'warden'
require 'rack/auth/basic'

module Authentication
  module Strategies
    class BasicAuthTerminalStrategy < Warden::Strategies::Base
      def valid?
        request.provided? && request.basic? && request.credentials
      end

      def store?
        false
      end

      def authenticate!
        terminal = authenticate_terminal(id, password)

        if terminal
          authentication_successful(terminal)
        else
          authentication_failed
        end
      end

      def authenticate_terminal(id, password)
        terminal = Terminal.find_by(id: id)
        return if terminal.blank?

        return terminal if terminal.valid_password?(password)
      end

      def authentication_successful(terminal)
        success!(terminal)
      end

      def authentication_failed
        headers('WWW-Authenticate' => %(#{auth_scheme} realm="#{realm}"))

        fail!('Unauthorized terminal request')
      end

      def request
        @request ||= Rack::Auth::Basic::Request.new(env)
      end

      def id
        request.credentials[0]
      end

      def password
        request.credentials[1]
      end

      def auth_scheme
        'Basic'
      end

      def realm
        'private terminal area'
      end
    end
  end
end
