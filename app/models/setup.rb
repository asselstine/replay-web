# A setup contains the details of a camera setup.  This can include how the
# camera is mounted, whether the camera was attached to a Strava account.
class Setup < ActiveRecord::Base
  has_many :setup_uploads
  has_many :video_uploads,
           through: :setup_uploads, source: :upload, class_name: 'VideoUpload'
  has_many :photo_uploads,
           through: :setup_uploads, source: :upload, class_name: 'PhotoUpload'
  has_many :videos, through: :video_uploads
  has_many :photos, through: :photo_uploads

  enum location: {
    static: 0,
    strava: 1
  }

  belongs_to :user

  validates :name, presence: true
  validates :range_m, numericality: { greater_than: 0 }
  validates_numericality_of :latitude, :longitude

  def self.with_videos_during(start_at, end_at)
    joins(:videos).merge(Video.during(start_at, end_at))
  end

  def self.with_photos_during(start_at, end_at)
    joins(:photos).merge(Photo.during(start_at, end_at))
  end

  def videos_during(start_at, end_at)
    videos.during(start_at, end_at)
  end

  def photos_during(start_at, end_at)
    photos.during(start_at, end_at)
  end

  def coords
    @coords ||= [latitude, longitude]
  end

  def coords_at(time)
    if strava?
      activity = user.activity_at(time)
      activity.coords_at(time) if activity
    else
      coords
    end
  end
end
