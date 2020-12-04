class Link < ApplicationRecord
  GIST_TEMPLATE = %r{gist.github.com/(\w*)/(\w*)}.freeze

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def gist?
    GIST_TEMPLATE.match?(url)
  end

  def gist_id
    GIST_TEMPLATE.match(url)[2]
  end
end
