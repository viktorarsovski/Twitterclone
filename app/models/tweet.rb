class Tweet < ApplicationRecord
  MINIMUM_TITLE_LENGTH = 5
  MAKSIMUM_BODY_LENGTH = 140

  has_many :comments, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { minimum: MINIMUM_TITLE_LENGTH }
  validates :body, presence: true, length: { maximum: MAKSIMUM_BODY_LENGTH }
end
