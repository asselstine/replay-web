class AddRecordingSessionToCamera < ActiveRecord::Migration
  def change
    add_reference :cameras, :recording_session, index: true, foreign_key: true
    remove_reference :cameras, :user
  end
end
