class Photo < ActiveRecord::Base
  TIME_MARGIN_OF_ERROR = 1

  belongs_to :user
  belongs_to :camera
  mount_uploader :image, PhotoUploader

  def location_at(datetime)
    if camera
      camera.locations.interpolate_at(datetime)
    else
      user.locations.interpolate_at(datetime)
    end
  end

  def self.at(datetime)
    where('timestamp < ?', datetime.since(TIME_MARGIN_OF_ERROR))
      .where('timestamp >= ?', datetime.ago(TIME_MARGIN_OF_ERROR))
  end
end
