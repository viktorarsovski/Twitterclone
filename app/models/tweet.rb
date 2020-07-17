class Tweet < ApplicationRecord
  has_many :comments
  has_many :comments, dependent: :destroy
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { maximum: 140 }
end
