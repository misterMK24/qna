require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:best_answer).class_name('Answer').optional }
  it { should belong_to(:user).with_foreign_key('user_id') }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it {should have_many_attached :files }
end
