FactoryBot.define do
  factory :answer do
    body { "Body" }
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
