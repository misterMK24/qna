require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:authored_questions).class_name('Question').with_foreign_key('author_id') }
  it { should have_many(:authored_answers).class_name('Answer').with_foreign_key('author_id') }
end
