FactoryGirl.define do
  factory :location do
    trackable {
      create(:camera)
    }
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
