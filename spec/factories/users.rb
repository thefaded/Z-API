FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    gender { User.genders.keys[rand(User.genders.keys.count)] }
    phone { "8999#{rand(9_999_999)}" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
