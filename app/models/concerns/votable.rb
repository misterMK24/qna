module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def resource_rating
    votes.pluck(:count).sum
  end
end
