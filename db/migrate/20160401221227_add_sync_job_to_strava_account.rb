class AddSyncJobToStravaAccount < ActiveRecord::Migration
  def change
    change_table :strava_accounts do |t|
      t.integer :sync_job_status, default: StravaAccount.sync_job_statuses[:no_job]
    end
  end
end
