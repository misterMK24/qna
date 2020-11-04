FactoryBot.define do
  factory :question do
    title { "Title" }
    body { "Body" }
    author factory: :user

    trait :invalid do
      title { nil }
    end

    factory :question_with_answers do
      transient do
        answers_count { 3 }
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
        
        question.reload
      end
    end
  end
end
