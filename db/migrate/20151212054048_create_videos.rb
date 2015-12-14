class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.references :camera
      t.string :source
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
