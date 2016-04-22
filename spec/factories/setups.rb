FactoryGirl.define do
  factory :setup do
    range_m 10
    timestamp Time.zone.now
    latitude { (rand - 0.5) * 180 }
    longitude { (rand - 0.5) * 360 }
    association :camera
  end
end
