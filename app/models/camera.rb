class Camera < ActiveRecord::Base
  include Trackable

  # Transfer Function:
  # Bell curve with a tweak to support range
  def self.bell(x)
    Math::E**-[x, 100.0].min**2
  end

  MIN_STRENGTH = Camera.bell(1)
  #
  # has_many :locations, -> { order(timestamp: :asc) },
  #          as: :trackable,
  #          dependent: :destroy,
  #          inverse_of: :trackable
  # accepts_nested_attributes_for :locations

  has_one :time_series_data, as: :trackable, dependent: :destroy
  accepts_nested_attributes_for :time_series_data

  delegate :start_at, :end_at, :coords_at, to: :time_series_data

  has_many :videos, inverse_of: :camera, dependent: :destroy
  has_many :photos, dependent: :destroy
  belongs_to :user
  belongs_to :recording_session

  validates :range_m, numericality: { greater_than: 0 }, allow_nil: true
  validates_presence_of :name

  def self.with_video_during(start_at, end_at)
    joins(:videos).merge(Video.during(start_at, end_at))
  end

  def self.with_video_containing(start_at, end_at = start_at)
    joins(:videos).merge(Video.containing(start_at, end_at))
  end

  def static_location(timestamp:, latitude:, longitude:)
    time_series_data.destroy if time_series_data
    attrs = { timestamps: [timestamp],
              latitudes: [BigDecimal.new(latitude)],
              longitudes: [BigDecimal.new(longitude)] }
    if persisted?
      create_time_series_data(attrs)
    else
      build_time_series_data(attrs)
    end
  end
end
