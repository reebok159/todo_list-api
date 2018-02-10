FactoryBot.define do
  factory :task do
    name { FFaker::Book.author }
    deadline nil
    completed false
    project
  end
end
