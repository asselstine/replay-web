FactoryGirl.define do
  factory :video do
    association :user
    thumbnail { create(:photo) }
    start_at DateTime.now
    end_at do
      start_at.since(1)
    end
    file '/dan_session1-frame.mp4'
  end
end
