class Photo < ActiveRecord::Base
  belongs_to :user
  mount_uploader :image, PhotoUploader
  reverse_geocoded_by :latitude, :longitude

  validate do
    if latitude.nil? or longitude.nil?
      ls = user.location_samples.closest_to(timestamp)
      if ls
        self.latitude = ls.latitude
        self.longitude = ls.longitude
      else
        errors.add(:image, 'Could not extract coordinates or find coordinates from history.')
      end
    end
  end

end
