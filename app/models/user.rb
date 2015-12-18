class User < ActiveRecord::Base
  include Trackable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :edits
  has_many :photos
  has_many :rides
  has_many :locations, :through => :rides
  has_one :strava_account

  accepts_nested_attributes_for :photos

  def feed_photos
    _photos = []
    start_at = feed_start_at
    end_at = feed_end_at
    return _photos if start_at.nil? || end_at.nil?
    while start_at < end_at
      _photos += feed_photos_during(start_at, start_at + 1.second)
      start_at += 1.second 
    end
    _photos
  end

  def feed_photos_during(start_at, end_at)
    _photos = []
    Camera.all.each do |camera|
      if camera.strength(start_at, self) >= Camera::MIN_STRENGTH
        _photos += camera.photos.during(start_at, end_at) 
      end
    end
    _photos
  end

  def feed_start_at
    locations.with_timestamp.order(timestamp: :asc).first.try(:timestamp)
  end

  def feed_end_at
    locations.with_timestamp.order(timestamp: :desc).first.try(:timestamp)
  end
end
