FactoryGirl.define do
  factory :video do
    association :user
    thumbnail { create(:photo) }
    start_at DateTime.now
    end_at do
      start_at.since(1)
    end
    file '/dan_session1-frame.mp4'
    after(:create) do |video, _|
      job = video.jobs.create!(output_type: :web, status: :complete)
      job.outputs.create!(key: '/dan_session1-frame.mp4',
                          preset_id: 'FAKE',
                          container_format: 'mp4')
    end
  end
end
