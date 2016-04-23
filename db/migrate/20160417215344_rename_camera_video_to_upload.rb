class RenameCameraVideoToUpload < ActiveRecord::Migration
  def change
    rename_table :camera_videos, :uploads
  end
end
