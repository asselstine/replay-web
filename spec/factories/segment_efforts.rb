FactoryGirl.define do
  factory :segment_effort do
    strava_segment_effort_id SecureRandom.uuid
    name 'FirstName'
    start_at DateTime.now
    end_at DateTime.now.since(10.seconds)
    elapsed_time 10.seconds
    moving_time 10.seconds
    start_index 1
    end_index 4
    kom_rank 2
    pr_rank 1
    activity
    segment
  end
end
