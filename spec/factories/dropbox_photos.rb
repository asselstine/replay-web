FactoryGirl.define do
  factory :dropbox_photo do
    association :dropbox_event
    sequence(:path) do |n|
      "/photos/photo#{n}/1x1.png"
    end
    photo Rails.root.join('spec', 'fixtures', '1x1_empty.jpg').open
    latitude { (rand - 0.5) * 180 }
    longitude { (rand - 0.5) * 360 }
  end
end
