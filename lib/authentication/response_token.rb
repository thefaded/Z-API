module Authentication
  class ResponseToken
    attr_reader :app

    HTTP_SUCCESS_CODES = {
      BEGIN: 200,
      END: 299
    }.freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      res = app.call(env)

      res[1]['Access-Token'] = token if success_result?(res[0]) && token.present?
      res
    end

    private

    def current_user
      env['warden'].user
    end

    def token
      current_user&.token
    end

    def success_result?(status_code)
      status_code.between?(HTTP_SUCCESS_CODES[:BEGIN], HTTP_SUCCESS_CODES[:END])
    end
  end
end
