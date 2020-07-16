class Comment < ApplicationRecord
  belongs_to :tweet

  validates :commenter, :body, presence: true
end

