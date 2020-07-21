class Comment < ApplicationRecord
  belongs_to :tweet
  belongs_to :user

  validates :body, presence: true
end

