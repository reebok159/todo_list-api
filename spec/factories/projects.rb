FactoryBot.define do
  factory :project do
    user
    name { FFaker::Book.title }

    trait :with_tasks do
      after(:create) do |proj|
        create_list(:task, 3, project: proj)
      end
    end
  end
end
