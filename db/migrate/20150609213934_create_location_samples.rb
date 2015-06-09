class CreateLocationSamples < ActiveRecord::Migration
  def change
    create_table :location_samples do |t|
      t.float :latitude
      t.float :longitude
      t.datetime :timestamp

      t.timestamps null: false
    end
  end
end
