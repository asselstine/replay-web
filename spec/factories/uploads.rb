FactoryGirl.define do
  factory :upload do
    association :user
    before :save do |upload, _|
      upload.setups << create(:setup, user: upload.user) if upload.setups.empty?
    end
  end

  factory :video_upload, class: VideoUpload, parent: :upload do
    association :video
  end

  factory :photo_upload, class: PhotoUpload, parent: :upload do
    association :photo
  end
end
