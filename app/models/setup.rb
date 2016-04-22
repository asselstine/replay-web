class Setup < ActiveRecord::Base
  belongs_to :camera
  has_many :videos, through: :camera
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

  def self.with_video_during(start_at, end_at)
    joins(:videos).merge(Video.during(start_at, end_at))
  end

  def self.with_video_containing(start_at, end_at = start_at)
    joins(:videos).merge(Video.containing(start_at, end_at))
  end

  def coords
    @coords ||= [latitude, longitude]
  end
end
