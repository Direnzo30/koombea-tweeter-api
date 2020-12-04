FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email(name: Faker::Name.first_name + rand(1..9999).to_s + Faker::Name.last_name) }
    username { (Faker::Internet.username + rand(1..9999).to_s) }
    password { Faker::Internet.password }
  end
end
