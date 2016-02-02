FactoryGirl.define do
  factory :video do
    association :camera
    start_at DateTime.now
    end_at do
      start_at.since(1)
    end
    source_key 'uploads/to_here.mp3'
    mp4_url Rails.root.join('spec/fixtures/dan_session1-frame.mp4')
  end
end
