class RenameLocationSamplesToLocations < ActiveRecord::Migration
  def change
    rename_table :location_samples, :locations
  end
end
