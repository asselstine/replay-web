FactoryGirl.define do
  factory :user do
    sequence(:email) do |n|
      "subject#{n}@fake.com"
    end
    password 'password'
    password_confirmation 'password'
  end
end
