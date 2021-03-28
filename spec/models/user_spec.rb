require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:nullify) }
  it { should have_many(:rewards).dependent(:nullify) }
  it { should have_many(:votes).dependent(:nullify) }
end
