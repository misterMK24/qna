require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).with_foreign_key('user_id') }

  it {should have_many_attached :files }

  it { should validate_presence_of :body }
end
