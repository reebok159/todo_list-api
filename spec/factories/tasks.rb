FactoryBot.define do
  factory :task do
    name { FFaker::Book.author }
    completed { false }
    project
  end
end
