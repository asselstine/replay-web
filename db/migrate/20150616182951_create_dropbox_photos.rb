class CreateDropboxPhotos < ActiveRecord::Migration
  def change
    create_table :dropbox_photos do |t|
      t.string :photo
      t.string :path
      t.string :rev
      t.references :dropbox_event, index: true, foreign_key: true
      t.datetime :timestamp

      t.timestamps null: false
    end
  end
end
