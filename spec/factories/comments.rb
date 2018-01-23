FactoryGirl.define do
  factory :comment do
    text FFaker::Lorem.sentence(5)
    task
  end
end
