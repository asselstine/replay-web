class CreateCameraVideos < ActiveRecord::Migration
  def change
    create_table :camera_videos do |t|
      t.references :camera
      t.references :video
    end
  end
end
