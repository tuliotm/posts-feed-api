class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :profile_photo
end
