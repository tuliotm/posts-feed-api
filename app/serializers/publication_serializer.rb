# frozen_string_literal: true

class PublicationSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :files
  has_one :user
  has_many :comments
end
