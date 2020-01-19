module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :id, :email, :phone, :gender, :first_name, :last_name, :admin, :role
    end
  end
end
