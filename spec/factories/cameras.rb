FactoryGirl.define do
  factory :camera do
    sequence(:name) do |n|
      "Camera#{n}"
    end
    range_m 10
    association :recording_session

    transient do
      at nil
    end

    trait :static do
      transient do
        lat 0
        lng 0
        start_at DateTime.now
        end_at DateTime.now.since(30)
      end
      static true
      after :create do |camera, evaluator|
        camera.create_time_series_data timestamps: [evaluator.start_at],
                                       latitudes: [evaluator.lat],
                                       longitudes: [evaluator.lng]
        create(:video,
               camera: camera,
               start_at: evaluator.start_at,
               end_at: evaluator.end_at)
      end
    end
  end
end
