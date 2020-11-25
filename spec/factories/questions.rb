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

    trait :with_attachment do
      after(:create) do |question|
        file = Rails.root.join('spec', 'fixtures', 'file', 'racecar.jpg')
        image = ActiveStorage::Blob.create_after_upload!(io: File.open(file, 'rb'), filename: 'racecar.jpg', content_type: 'image/jpg')
        question.files.attach(image)

        question.reload
      end
    end

    trait :with_link do
      after(:create) do |question|
        question.links.create(name: 'test link', url: 'https://gist.github.com')

        question.reload
      end
    end
  end
end
