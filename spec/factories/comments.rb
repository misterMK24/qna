FactoryBot.define do
  factory :comment do
    body { 'comment body' }
    user
    with_question

    trait :with_question do
      association :commentable, factory: :question
    end

    trait :with_answer do
      association :commentable, factory: :answer
    end
  end
end
