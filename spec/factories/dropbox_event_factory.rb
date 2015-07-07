require 'digest'

FactoryGirl.define do
  factory :dropbox_event do
    sequence(:cursor) do |n|
      "cursor#{n}"
    end
    path '/foo/bar'
    association :user
  end
end