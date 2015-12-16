class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.float :exif_latitude
      t.float :exif_longitude
      t.datetime :timestamp
      t.string :image
      t.references :user

      t.timestamps null: false
    end
  end
end
