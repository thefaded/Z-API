module Api
  module V1
    class UsersController < ApiController
      def index
        render json: User.all
      end

      def show
        render json: User.find_by(id: params[:id])
      end

      def update
        @user = User.find_by(id: params[:id])

        if @user.update(user_params)
          render json: @user
        else
          render json: {
            errors: @user.errors.messages
          }
        end
      end

      private

      def user_params
        params.permit(*::ClientCreationForm::CLIENT_ATTRIBUTES)
      end
    end
  end
end
