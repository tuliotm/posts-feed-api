# frozen_string_literal: true

class Comment < ApplicationRecord
  #== ASSOCIATIONS =======================================
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_one_attached :file
end
