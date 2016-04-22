class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :edits, dependent: :destroy
  has_many :cameras
  has_many :setups, through: :cameras
  has_many :photos, dependent: :destroy
  has_many :uploads
  has_many :activities, dependent: :destroy
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
end
