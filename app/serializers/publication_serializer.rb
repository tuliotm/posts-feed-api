# frozen_string_literal: true

class PublicationSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :file
  has_one :user
  has_many :comments

  def file
    if object.file.attached?
      file = object.file
      {
        filename: file.filename.to_s,
        content_type: file.content_type,
        byte_size: file.byte_size
      }
    else
      {}
    end
  end
end
