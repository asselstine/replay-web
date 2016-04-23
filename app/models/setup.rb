class Setup < ActiveRecord::Base
  has_many :setup_uploads
  has_many :uploads,
           through: :setup_uploads
  has_many :setup_photos
  has_many :photos,
           through: :setup_photos

  validates :range_m, numericality: { greater_than: 0 }
  validates_numericality_of :latitude, :longitude

  def self.with_uploads_during(start_at, end_at)
    joins(:uploads).merge(Upload.during(start_at, end_at))
  end

  def uploads_during(frame)
    uploads.during(frame.start_at, frame.end_at)
  end

  def self.with_photos_during(start_at, end_at)
    joins(:photos).merge(Photo.during(start_at, end_at))
  end

  def photos_during(frame)
    photos.during(frame.start_at, frame.end_at)
  end

  def coords
    @coords ||= [latitude, longitude]
  end
end
