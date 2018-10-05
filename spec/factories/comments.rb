FactoryBot.define do
  factory :comment do
    text { FFaker::Lorem.characters(25) }
    task
  end
end
