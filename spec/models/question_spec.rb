require 'rails_helper'
require 'models/concerns/votable_spec'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should belong_to(:best_answer).class_name('Answer').optional }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many_attached :files }

  it { should accept_nested_attributes_for :links }
end
