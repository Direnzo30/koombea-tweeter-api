FactoryBot.define do
  factory :tweet do
    association :user, factory: :user
    content { Faker::Lorem.characters(number: rand(10..280))}
  end
end