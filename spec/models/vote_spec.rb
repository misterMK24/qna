require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:vote) { create(:vote, votable: question, user: user) }

  it 'has an associations with votable and user' do
    expect(vote.votable).to be(question)
    expect(vote.user).to be(user)
  end
end
