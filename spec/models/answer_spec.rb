require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).with_foreign_key('user_id') }
  it { should have_many(:links).dependent(:destroy) }

  it {should have_many_attached :files }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
end
