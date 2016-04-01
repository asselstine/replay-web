class AddSyncJobToStravaAccount < ActiveRecord::Migration
  def change
    change_table :strava_accounts do |t|
      t.integer :sync_job_status
    end
  end
end
