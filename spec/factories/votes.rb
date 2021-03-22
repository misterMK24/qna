FactoryBot.define do
  factory :vote do
    positive { true }
    user
    with_question

    trait :with_question do
      association :votable, factory: :question
    end

    trait :with_answer do
      association :votable, factory: :answer
    end
  end
end
