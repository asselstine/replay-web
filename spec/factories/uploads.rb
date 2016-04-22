FactoryGirl.define do
  factory :upload do
    association :video
    association :user
    before :save do |upload, _|
      upload.start_at = upload.video.start_at
      upload.end_at = upload.video.end_at
    end
  end
end
