# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment, :file
  has_one :user
  has_one :commentable

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
