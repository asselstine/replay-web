class AddDateToRecordingSession < ActiveRecord::Migration
  def change
    add_column :recording_sessions, :start_at, :datetime
  end
end
