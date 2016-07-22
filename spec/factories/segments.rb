FactoryGirl.define do
  factory :segment do
    name 'SegmentName'
    activity_type 'Ride'
    distance 12.23
    average_grade 1.2
    maximum_grade 2.3
    elevation_high 213
    elevation_low 100
    city 'Vancouver'
    state 'BC'
    country 'Canada'
    is_private false
  end
end
