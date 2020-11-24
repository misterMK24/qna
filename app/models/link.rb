class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def is_gist?
    GIST_TEMPLATE.match?(self.url)
  end

  def gist_id
    GIST_TEMPLATE.match(self.url)[2]
  end

  private

  GIST_TEMPLATE = /gist\.github\.com\/(\w*)\/(\w*)/
end
