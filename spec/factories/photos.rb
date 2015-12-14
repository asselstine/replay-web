FactoryGirl.define do
  factory :photo do
    association :user
    image Rails.root.join('spec','fixtures','1x1_empty.jpg').open
  end
end
