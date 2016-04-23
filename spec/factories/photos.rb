FactoryGirl.define do
  factory :photo do
    association :user
    timestamp DateTime.now
    image Rails.root.join('spec', 'fixtures', '1x1_empty.jpg').open
    exif_latitude do
      (rand - 0.5) * 180
    end
    exif_longitude do
      (rand - 0.5) * 360
    end
  end
end
