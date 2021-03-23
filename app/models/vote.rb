class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, optional: true
  belongs_to :user

  validates :count, inclusion: { in: [1, -1] }
  validates :user_id, presence: true, uniqueness: { scope: :votable_id, message: 'has already voted' }
  validate :authorship

  private

  def authorship
    errors.add(:user, 'is author of this resource') if user == votable.user
  end
end
