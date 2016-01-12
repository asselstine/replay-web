FactoryGirl.define do 
  factory :camera do
    sequence(:name) do |n|
      "Camera#{n}"
    end
    range_m 10
    association :user

    transient do
      video_at nil
    end

    trait :with_static do
      transient do
        lat 0
        lng 0
        video_at DateTime.now
      end
      static true
      after :create do |camera, evaluator|
        create(:location, latitude: evaluator.lat, longitude: evaluator.lng, trackable: camera, timestamp: evaluator.video_at)
      end
    end

    after :create do |camera, evaluator|
      create(:video, 
             camera: camera, 
             start_at: evaluator.video_at, end_at: evaluator.video_at.since(30)) if evaluator.video_at
    end
  end
end
