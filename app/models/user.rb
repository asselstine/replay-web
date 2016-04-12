class User < ActiveRecord::Base
  include Trackable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :edits, dependent: :destroy
  has_many :cameras
  has_many :photos, dependent: :destroy
  has_many :rides, dependent: :destroy
  has_many :time_series_data, through: :rides
  has_many :recording_sessions, dependent: :destroy
  has_one :strava_account, dependent: :destroy

  accepts_nested_attributes_for :photos

  def feed_photos
    photos = []
    return photos if feed_start_at.nil? || feed_end_at.nil?
    frame = Frame.new(start_at: feed_start_at,
                      end_at: feed_end_at,
                      user: self)
    loop do
      photos += feed_photos_during(frame)
      break unless frame.next!
    end
    photos
  end

  def feed_photos_during(frame)
    photos = []
    user_eval = UserEvaluator.new(user: self, frame: frame)
    Camera.all.each do |camera|
      if CameraEvaluator.new(camera: camera, frame: frame)
                        .strength(user_eval) >= Camera::MIN_STRENGTH
        photos += camera.photos.during(frame.cut_start_at, frame.cut_end_at)
      end
    end
    photos
  end

  def feed_start_at
    rides
      .order(strava_start_at: :asc)
      .first
      .time_series_data.try(:timestamps).try(:first) || DateTime.now.utc
  end

  def feed_end_at
    rides
      .order(strava_start_at: :desc)
      .first
      .time_series_data.try(:timestamps).try(:last) || DateTime.now.utc
  end
end
