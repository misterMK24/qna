FactoryBot.define do
  factory :reward do
    title { "reward" }
    question
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'file', 'racecar.jpg'), 'image/jpg') }

    trait :with_user do
      after(:create) do |reward|
        user = create(:user)
        reward.update(user: user)

        reward.reload
      end
    end
  end
end
