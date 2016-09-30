FactoryGirl.define do
  factory :segment_effort do
    strava_segment_effort_id SecureRandom.uuid
    sequence(:name) { |n| "SegmentEffort #{n}" }
    kom_rank 2
    pr_rank 1
    activity
    segment

    before(:create) do |segment_effort, _|
      start_at = segment_effort.activity.timestamps.first
      end_at = segment_effort.activity.timestamps.last
      length = segment_effort.activity.timestamps.length
      segment_effort.start_index = 0
      segment_effort.end_index = length - 1
      segment_effort.elapsed_time = end_at - start_at
      segment_effort.moving_time = end_at - start_at
    end
  end
end
