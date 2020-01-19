module Api
  module V1
    class ProductsController < ApiController
      def index
        render json: Product.all.where(hidden: false)
      end
    end
  end
end
