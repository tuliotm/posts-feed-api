# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  #== VALIDATIONS ========================================
  validates :email, uniqueness: { case_sensitive: false }, length: { in: 3..255 }, presence: true
  validates :name, presence: true, length: { in: 3..255 }
  validates :password, presence: true, on: :create

  #== ASSOCIATIONS =======================================
  has_many :comments
  has_many :publications
end
