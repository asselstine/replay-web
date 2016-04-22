class Photo < ActiveRecord::Base
  TIME_MARGIN_OF_ERROR = 1
  DEFAULT_RANGE_M = 15

  belongs_to :user
  belongs_to :camera
  mount_uploader :image, PhotoUploader

  validates_presence_of :user, :camera, :image, :timestamp

  before_save :find_or_create_camera
  before_save :process_exif_coords,
              if: 'exif_latitude_changed? && exif_longitude_changed?'
  before_save :infer_user_coords, on: :create, if: 'exif_latitude.nil?'

  def self.during(start_at, end_at)
    where('photos.timestamp >= ?', start_at)
      .where('photos.timestamp <= ?', end_at)
  end

  protected

  def find_or_create_camera
    if camera.nil?
      self.camera = Camera.create(name: "Virtual Camera for photo ##{id}")
    end
    camera
  end

  def process_exif_coords
    set_camera_location(timestamp, exif_latitude, exif_longitude)
  end

  def set_camera_location(timestamp, latitude, longitude)
    camera.setups.create!(timestamp: timestamp,
                          latitude: latitude,
                          longitude: longitude,
                          range_m: DEFAULT_RANGE_M)
  end
end
