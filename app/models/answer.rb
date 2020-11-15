class Answer < ApplicationRecord
  belongs_to :question
  # belongs_to :question_best_answer, class_name: 'Question', foreign_key: 'best_answer_id', otional: true
  belongs_to :user, foreign_key: 'user_id'

  validates :body, presence: true
end
