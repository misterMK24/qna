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

    factory :user_with_answers do
      transient do
        answers_count { 3 }
      end

      after(:create) do |user, evaluator|
        create_list(:answer, evaluator.answers_count, author: user)
        
        user.reload
      end
    end

    factory :user_with_questions do
      transient do
        questions_count { 3 }
      end

      after(:create) do |user, evaluator|
        create_list(:question, evaluator.questions_count, author: user)
        
        user.reload
      end
    end
  end
end
