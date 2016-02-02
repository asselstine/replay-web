FactoryGirl.define do
  factory :location do
    association :trackable, factory: :camera
    latitude { (rand - 0.5) * 180 }
    longitude { (rand - 0.5) * 360 }
    sequence(:timestamp) do |n|
      n.seconds.ago
    end
  end
end
