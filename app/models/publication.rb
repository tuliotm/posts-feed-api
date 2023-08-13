# frozen_string_literal: true

class Publication < ApplicationRecord
  #== VALIDATIONS ========================================
  validates :title, presence: true

  #== ASSOCIATIONS =======================================
  belongs_to :user
  has_many :comments, as: :commentable
  has_one_attached :file
end
