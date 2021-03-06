require 'rails_helper'
require 'models/concerns/votable_spec'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'

  it { should belong_to :question }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }

  it { should have_many_attached :files }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
end
