FactoryBot.define do
  factory :answer do
    body { "Body" }
    question
    author factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
