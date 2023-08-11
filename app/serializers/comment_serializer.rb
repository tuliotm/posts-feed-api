class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment, :file
  has_one :user
  has_one :commentable
end