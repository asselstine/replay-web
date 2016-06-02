class AddSourceVideoToVideoDraft < ActiveRecord::Migration
  def change
    change_table :drafts do |t|
      t.integer :source_video_id, index: true
    end
  end
end
