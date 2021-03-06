FactoryBot.define do
  # allows to create unique emails for user
  # if sequence name match with an attribute name, we could just put into
  # factory block a name of the attribute. It'll call a sequence block
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    # calls a sequence email
    email
    password { '12345678' }
    password_confirmation { '12345678' }

    trait :with_answer do
      transient do
        amount { 1 }
      end

      after(:create) do |user, evaluator|
        create_list :answer, evaluator.amount, user: user
        user.reload
      end
    end

    trait :with_question do
      transient do
        amount { 1 }
      end

      after(:create) do |user, evaluator|
        create_list :question, evaluator.amount, user: user
        user.reload
      end
    end
  end
end
