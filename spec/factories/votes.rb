FactoryBot.define do
  factory :vote do
    count { 1 }
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
