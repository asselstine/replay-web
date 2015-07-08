FactoryGirl.define do
  factory :location_sample do
    association :ride
    latitude {
      (rand - 0.5) * 180
    }
    longitude {
      (rand - 0.5) * 360
    }
    sequence(:timestamp) { |n|
      n.seconds.ago
    }
  end
end