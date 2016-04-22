FactoryGirl.define do
  factory :camera do
    sequence(:name) do |n|
      "Camera#{n}"
    end
    association :recording_session

    trait :static do
      transient do
        lat 0
        lng 0
        start_at DateTime.now
        end_at DateTime.now.since(30)
      end
      static true
      after :create do |camera, evaluator|
        if camera.setups.empty?
          camera.create_setup timestamp: evaluator.start_at,
                              range_m: 10,
                              latitude: evaluator.lat,
                              longitude: evaluator.lng
        end
        create(:video,
               camera: camera,
               start_at: evaluator.start_at,
               end_at: evaluator.start_at.since(30.seconds))
      end
    end
  end
end
