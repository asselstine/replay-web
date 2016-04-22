class Setup < ActiveRecord::Base
  belongs_to :camera
  has_many :uploads, through: :camera
  has_many :photos, through: :camera
  validates_presence_of :timestamp
  validates :range_m, numericality: { greater_than: 0 }
  validates_numericality_of :latitude, :longitude

  # want ones with the greatest timestamp for a camera less than the passed time
  scope :at_time, (lambda do |time|
    joins(<<-SQL
      LEFT OUTER JOIN setups AS s2
        ON setups.camera_id = s2.camera_id
        AND setups.timestamp < s2.timestamp
    SQL
         )
       .where('setups.timestamp < :time AND s2.timestamp < :time', time: time)
       .where('s2.timestamp IS NULL')
  end)

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
