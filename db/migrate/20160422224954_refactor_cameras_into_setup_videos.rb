class RefactorCamerasIntoSetupVideos < ActiveRecord::Migration
  def change
    remove_reference :uploads, :camera
    remove_reference :photos, :camera
    remove_reference :setups, :camera
    drop_table :cameras
    change_table :setups do |t|
      t.text :name
    end
    remove_column :setups, :timestamp
    create_table :setup_uploads do |t|
      t.references :setup
      t.references :upload
    end
    create_table :setup_photos do |t|
      t.references :setup
      t.references :photo
    end
  end
end
