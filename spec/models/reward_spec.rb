require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user).optional }
  it { is_expected.to validate_attached_of(:image) }
  it { is_expected.to validate_content_type_of(:image).allowing('image/png', 'image/jpg', 'image/jpeg') }

  it { should validate_presence_of(:title) }
end
