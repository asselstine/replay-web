FactoryGirl.define do
  factory :photo do
    association :user
    timestamp DateTime.now
    image Rails.root.join('spec','fixtures','1x1_empty.jpg').open
    exif_latitude {
      (rand - 0.5) * 180
    }
    exif_longitude {
      (rand - 0.5) * 360
    }
  end
end
