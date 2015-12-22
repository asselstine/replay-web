class Ride < ActiveRecord::Base
  belongs_to :user
  has_many :locations, as: :trackable
  accepts_nested_attributes_for :locations

  def to_s
    "Ride(#{id}) { user: #{user.id}, strava_activity_id: #{strava_activity_id}, strava_name: #{strava_name}, strava_start_at: #{strava_start_at}"
  end
end
