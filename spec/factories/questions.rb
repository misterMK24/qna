FactoryBot.define do
  factory :question do
    title { "Title" }
    body { "Body" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_answer do
      transient do
        amount { 1 }
      end

      after(:create) do |question, evaluator|
        create_list :answer, evaluator.amount, question: question
        question.reload
      end
    end
  end
end
