module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def resource_rating
    votes.where(positive: true).count - votes.where(positive: false).count
  end
end
