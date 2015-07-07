class Photo < ActiveRecord::Base
  belongs_to :user
  mount_uploader :image, PhotoUploader
  reverse_geocoded_by :latitude, :longitude

  before_save do
    if latitude.nil? or longitude.nil?
      ls = user.location_samples.closest_to(timestamp)
      self.latitude = ls.latitude
      self.longitude = ls.longitude
    end
  end

end
