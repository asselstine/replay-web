class Photo < ActiveRecord::Base
  TIME_MARGIN_OF_ERROR = 1
  DEFAULT_RANGE_M = 15 

  belongs_to :user
  belongs_to :camera
  mount_uploader :image, PhotoUploader

  validates_presence_of :user
  validates_presence_of :image
  validates_presence_of :timestamp

  before_save :find_or_create_camera
  before_save :process_exif_coords, 
    if: 'exif_latitude_changed? && exif_longitude_changed?'
  before_save :infer_user_coords, on: :create, if: 'exif_latitude.nil?'

  def self.during(start_at, end_at)
    where('timestamp >= ?', start_at)
      .where('timestamp <= ?', end_at)
  end

  protected

  def find_or_create_camera
    if self.camera.nil?
      self.camera = Camera.create(user: user, range_m: DEFAULT_RANGE_M)
    end
    self.camera
  end

  def process_exif_coords
    Location.create(trackable: find_or_create_camera, latitude: exif_latitude, longitude: exif_longitude)
  end

  def infer_user_coords
    coords = user.coords_at(self.timestamp)
    if coords
      Location.create(trackable: camera, latitude: coords[0], longitude: coords[1])
    else
      errors.add(:location, "Cannot geotag this photo; no geographic info available.")
    end
  end
end
