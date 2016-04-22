FactoryGirl.define do
  factory :setup do
    range_m 10
    latitude { (rand - 0.5) * 180 }
    longitude { (rand - 0.5) * 360 }
  end
end
