class LocationSample < ActiveRecord::Base
  belongs_to :ride

  reverse_geocoded_by :latitude, :longitude
end
