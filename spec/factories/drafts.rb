FactoryGirl.define do
  factory :draft do
    association :setup
    association :activity
    type 'Draft'
  end

  factory :video_draft, parent: :draft, class: 'VideoDraft' do
    type 'VideoDraft'
    association :source_video, factory: :video
    association :video, factory: :video
    start_at DateTime.now
    end_at { start_at.since(0.1) }
  end

  factory :photo_draft, parent: :draft, class: 'PhotoDraft' do
    type 'PhotoDraft'
    association :photo, factory: :photo
  end
end
