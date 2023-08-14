# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment, :file, :commentable_type
  has_one :commentable
  has_one :user

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
