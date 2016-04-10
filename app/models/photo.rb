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

  def coords
    CameraEvaluator.new(camera: camera, frame: Frame.new(start_at: timestamp,
                                                         end_at: timestamp))
                   .coords
  end

  protected

  def find_or_create_camera
    if camera.nil?
      self.camera = Camera.create(name: "Virtual Camera for photo ##{id}",
                                  range_m: DEFAULT_RANGE_M)
    end
    camera
  end

  def process_exif_coords
    set_camera_location(timestamp, exif_latitude, exif_longitude)
  end

  def infer_user_coords
    coords = UserEvaluator.new(user: user, frame: Frame.new(start_at: timestamp,
                                                            end_at: timestamp))
                          .coords
    if coords
      set_camera_location(timestamp, coords[0], coords[1])
    else
      errors.add(:location,
                 'Cannot geotag this photo; no geographic info available.')
    end
  end

  def set_camera_location(timestamp, latitude, longitude)
    attrs = { timestamps: [timestamp],
              latitudes: [latitude],
              longitudes: [longitude] }
    if camera.time_series_data.present?
      camera.time_series_data.update(attrs)
    else
      camera.create_time_series_data(attrs)
    end
  end
end
