class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.float :latitude
      t.float :longitude
      t.time :timestamp
      t.string :image
      t.references :user

      t.timestamps null: false
    end
  end
end
