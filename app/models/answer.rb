class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user, foreign_key: 'user_id'

  has_many_attached :files

  validates :body, presence: true
end
