class AddStravaActivityIdToRide < ActiveRecord::Migration
  def change
    add_column :rides, :strava_activity_id, :string
    add_column :rides, :strava_name, :string
    add_column :rides, :strava_start_at, :datetime
  end
end
