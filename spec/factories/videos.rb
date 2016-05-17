FactoryGirl.define do
  factory :video do
    association :user
    start_at DateTime.now
    end_at do
      start_at.since(1)
    end
    file File.open(Rails.root.join('app/assets/test/dan_session1-frame.mp4'))
  end
end
