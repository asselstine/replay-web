FactoryGirl.define do 
  factory :camera do
    range_m 10

    transient do
      video_at nil
    end

    trait :with_static do
      transient do
        lat 0
        lng 0
      end
      after :create do |camera, evaluator|
        create(:location, latitude: evaluator.lat, longitude: evaluator.lng, trackable: camera, timestamp: nil)
      end
    end

    after :create do |camera, evaluator|
      create(:video, 
             camera: camera, 
             start_at: evaluator.video_at, end_at: evaluator.video_at.since(30)) if evaluator.video_at
    end
  end
end