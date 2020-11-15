class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true
  
  def mark_as_best(answer)
		self.update(best_answer_id: answer)
	end
end
