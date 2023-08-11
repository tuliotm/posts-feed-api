class Comment < ApplicationRecord
  #== ASSOCIATIONS =======================================
  belongs_to :commentable, polymorphic: true
  belongs_to :user
end
