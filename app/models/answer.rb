class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  validates :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
end
