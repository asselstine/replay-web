class Camera < ActiveRecord::Base
  include Trackable

  # Transfer Function:
  # Bell curve with a tweak to support range
  def self.bell(x)
    Math::E**-[x, 100.0].min**2
  end

  MIN_STRENGTH = Camera.bell(1) 

  has_many :locations, as: :trackable
  has_many :videos, inverse_of: :camera
  has_many :photos
  belongs_to :user

  validates :range_m, numericality: { greater_than: 0 }, allow_nil: true
  
  def self.sort_by_strength(cameras, start_at, user)
    cameras.to_a.sort { |a, b|
      b.strength(start_at, user) <=> a.strength(start_at, user)
    }
  end

  def self.with_video_during(start_at, end_at)
    joins(:videos).merge(Video.during(start_at, end_at))
  end
  
  def strength(start_at, user)
    # The proximity method
    u_coords = user.coords_at(start_at)
    c_coords = coords_at(start_at) 
    return 0 unless u_coords && c_coords 
    kms = Geocoder::Calculations.distance_between(u_coords, c_coords, units: :km)
    Camera.bell(kms/(range_m/1000.0))
  end
end
