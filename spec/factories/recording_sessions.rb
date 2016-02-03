FactoryGirl.define do
  factory :recording_session do
    association :user
    name 'MyString'
    start_at DateTime.now
  end
end
