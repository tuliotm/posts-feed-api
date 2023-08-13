# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :profile_photo

  def profile_photo
    {
      filename: object.profile_photo.filename,
      content_type: object.profile_photo.content_type,
      byte_size: object.profile_photo.byte_size
    }
  end
end
