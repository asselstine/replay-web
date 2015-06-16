class CreateDropboxEvents < ActiveRecord::Migration
  def change
    create_table :dropbox_events do |t|
      t.string :cursor
      t.string :path
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
