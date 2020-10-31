FactoryBot.define do
  factory :answer do
    body { "Body" }
    question

    trait :invalid do
      body { nil }
    end
  end
end
