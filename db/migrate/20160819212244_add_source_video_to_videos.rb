class AddSourceVideoToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :source_video_id, :integer, index: true
  end
end
