class AddThumbnailToVideo < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.integer :thumbnail_id, index: true
    end
  end
end
