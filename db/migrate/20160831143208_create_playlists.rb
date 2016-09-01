class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.references :video
      t.references :job
      t.string :key

      t.timestamps null: false
    end
  end
end
