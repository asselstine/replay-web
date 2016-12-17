FactoryGirl.define do
  factory :setup do
    range_m 10
    sequence(:name) { |n| "Setup #{n}" }
    latitude { (rand - 0.5) * 180 }
    longitude { (rand - 0.5) * 360 }
    location :static
  end
end
