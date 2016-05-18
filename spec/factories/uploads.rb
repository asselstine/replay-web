FactoryGirl.define do
  factory :upload do
    association :video
    association :user
    before :save do |upload, _|
      upload.setups << create(:setup, user: upload.user) if upload.setups.empty?
    end
  end
end
