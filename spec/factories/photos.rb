FactoryGirl.define do
  factory :photo do
    association :user
    image Rails.root.join('spec','fixtures','1x1_empty.jpg').open
    latitude {
      (rand - 0.5) * 180
    }
    longitude {
      (rand - 0.5) * 360
    }
  end
end
