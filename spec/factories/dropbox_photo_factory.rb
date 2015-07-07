FactoryGirl.define do
  factory :dropbox_photo do
    association :dropbox_event
    photo Rails.root.join('spec','fixtures','1x1.png').open
    latitude {
      (rand - 0.5) * 360
    }
    longitude {
      (rand - 0.5) * 360
    }
  end
end