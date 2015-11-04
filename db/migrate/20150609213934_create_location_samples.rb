class CreateLocationSamples < ActiveRecord::Migration
  def change
    create_table :location_samples do |t|
      t.float :latitude
      t.float :longitude
      t.decimal :timestamp_in_seconds, :precision => 17, :scale => 3
      t.boolean :interpolated, :default => false

      t.timestamps null: false
    end
  end
end
