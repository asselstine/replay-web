class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :setups, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :draft_photos, through: :activities, dependent: :destroy
  has_many :draft_photo_photos, through: :draft_photos, source: :photo
  has_many :uploads, dependent: :destroy
  has_many :video_uploads
  has_many :jobs, through: :video_uploads
  has_many :photo_uploads
  has_many :activities, dependent: :destroy
  has_many :segment_efforts, through: :activities
  has_many :drafts, through: :activities
  has_many :time_series_data, through: :activities
  has_many :recording_sessions, dependent: :destroy
  has_one :strava_account, dependent: :destroy

  def feed_start_at
    activities
      .order(strava_start_at: :asc)
      .first
      .time_series_data.try(:timestamps).try(:first) || DateTime.now.utc
  end

  def feed_end_at
    activities
      .order(strava_start_at: :desc)
      .first
      .time_series_data.try(:timestamps).try(:last) || DateTime.now.utc
  end

  def activity_at(time)
    activities.at(time).first
  end
end
