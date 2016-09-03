class CreateStream < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :ts_key
      t.string :iframe_key
      t.string :playlist_key
      
      t.references :playlist
    end
  end
end
