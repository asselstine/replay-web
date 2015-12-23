class Camera < ActiveRecord::Base
  include Trackable

  # Transfer Function:
  # Bell curve with a tweak to support range
  def self.bell(x)
    Math::E**-[x, 100.0].min**2
  end

  MIN_STRENGTH = Camera.bell(1) 

  has_many :locations, as: :trackable, dependent: :destroy
  has_many :videos, inverse_of: :camera, dependent: :destroy
  has_many :photos, dependent: :destroy
  belongs_to :user

  validates :range_m, numericality: { greater_than: 0 }, allow_nil: true
  
  def self.sort_by_strength(cameras, context)
    cameras.to_a.sort { |a, b|
      b.strength(context) <=> a.strength(context)
    }
  end

  def self.with_video_during(start_at, end_at)
    joins(:videos).merge(Video.during(start_at, end_at))
  end

  def self.with_video_containing(start_at, end_at) 
    joins(:videos).merge(Video.containing(start_at, end_at))
  end
  
  def strength(context)
    # The proximity method
    u_coords = context.user_coords_at_cut
    c_coords = coords_at(context.cut_start_at) 
    # puts "Camera#strength: c id: #{id}: c_coords: #{c_coords}, u_coords: #{u_coords}, start_at: #{start_at.to_f}"
    return 0 unless u_coords && c_coords 
    kms = Geocoder::Calculations.distance_between(u_coords, c_coords, units: :km)
    bell = Camera.bell(kms/(range_m/1000.0))
    # puts "Camera#strength: kms #{kms} bell: #{bell}"
    bell
  end
end
