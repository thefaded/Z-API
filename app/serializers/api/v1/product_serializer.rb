module Api
  module V1
    class ProductSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers

      attributes :id, :name, :description, :price

      def price
        object.price.format
      end
    end
  end
end
