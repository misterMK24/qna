require 'rails_helper'

shared_examples 'votable' do
  it { should have_many(:votes).dependent(:destroy) }
end
