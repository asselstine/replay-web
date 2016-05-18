FactoryGirl.define do
  factory :upload do
    association :user
    filename 'dan_session1-frame.mp4'
    file_type 'video/mp4'
    file_size 33_000
    unique_id '3132klf'
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
