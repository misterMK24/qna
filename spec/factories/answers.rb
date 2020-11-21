FactoryBot.define do
  factory :answer do
    body { "Body" }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_attachment do
      after(:create) do |answer|
        file = Rails.root.join('spec', 'fixtures', 'file', 'racecar.jpg')
        image = ActiveStorage::Blob.create_after_upload!(io: File.open(file, 'rb'), filename: 'racecar.jpg', content_type: 'image/jpg')
        answer.files.attach(image)

        answer.reload
      end
    end
  end
end
