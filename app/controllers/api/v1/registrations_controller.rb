module Api
  module V1
    class RegistrationsController < ApiController
      def client_signup
        @client_form = ::ClientCreationForm.new(client_params)

        if @client_form.save
          render json: {
            user: @client_form.user
          }
        else
          render json: {
            errors: @client_form.errors.messages
          }, status: :bad_request
        end
      end

      private

      def client_params
        params.permit(*::ClientCreationForm::CLIENT_ATTRIBUTES)
      end
    end
  end
end
