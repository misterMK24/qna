require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).with_foreign_key('user_id').dependent(:destroy) }
  it { should have_many(:answers).with_foreign_key('user_id').dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
end
