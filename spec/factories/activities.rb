FactoryGirl.define do
  factory :activity do
    association :user
    sequence(:strava_name) do |n|
      "Activity#{n}"
    end
  end
end
