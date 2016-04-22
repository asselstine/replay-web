FactoryGirl.define do
  factory :upload do
    association :camera
    association :video
    before :save do |upload, _|
      upload.start_at = upload.video.start_at
      upload.end_at = upload.video.end_at
    end
  end
end
