FactoryGirl.define do
  factory :activity do
    association :user
    sequence(:strava_name) do |n|
      "Activity#{n}"
    end
    strava_activity_id SecureRandom.uuid
    strava_start_at Time.zone.now.ago(10.seconds).change(usec: 0)
    timestamps [0, 10, 20, 30]
    latitudes [-49.04, -49.041, -49.042, -49.043]
    longitudes [120.01, 120.02, 120.03, 120.04]
    velocities [23, 25, 21, 18]
  end
end
