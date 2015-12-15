class Camera < ActiveRecord::Base
  MIN_STRENGTH = 0.3

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
    query = <<-SQL
      (videos.start_at, videos.end_at) OVERLAPS (:start_at, :end_at)
    SQL
    joins(:videos)
      .where(query, start_at: start_at, end_at: end_at)
  end
  
  def self.find_candidate_ids(location, start_at, end_at)
    Location.ballpark_during(location, start_at, end_at).where(trackable_type: Camera).map(&:trackable_id)
  end

  def self.find_candidates(location, start_at, end_at)
    Camera.where(id: find_candidate_ids(location, start_at, end_at))
  end

  def strength(start_at, user)
    #the proximity method
    user_location = user.locations.interpolate_at(start_at)
    camera_location = locations.interpolate_at(start_at)
    return 0 unless user_location && camera_location
    kms = Geocoder::Calculations.distance_between(user_location, 
                                                camera_location, units: :km)
    # Transfer Function:
    # Bell curve with a tweak to support range
    bell(kms)
  end

  def self.find_video_candidates(location, start_at, end_at)
    camera_ids = find_candidate_ids(location, start_at, end_at)
    Camera.where(id: camera_ids).with_video_during(start_at, end_at)
  end

  protected

  def bell(distance_km)
    Math::E**-[distance_km/(range_m/1000.0), 100.0].min**2
  end
end
