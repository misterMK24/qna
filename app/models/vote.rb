class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, optional: true
  belongs_to :user

  validates :positive, inclusion: { in: [true, false] }
  validates :user_id, presence: true, uniqueness: { scope: :votable_id, message: 'has already voted' }
  validate :authorship

  private

  def authorship
    # byebug
    errors.add(:user, 'is author of this resource') if user == votable.user
  end
end
