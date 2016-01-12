class ChangeLatLngLocationsTypes < ActiveRecord::Migration
  def up
    remove_column :locations, :latitude, :float
    remove_column :locations, :longitude, :float
    add_column :locations, :latitude, :decimal, scale: 8, precision: 12, default: 49.2578263 
    add_column :locations, :longitude, :decimal, scale: 8, precision: 12, default: -123.1939534
  end
  def down
    remove_column :locations, :latitude, :decimal, scale: 8, precision: 12
    remove_column :locations, :longitude, :decimal, scale: 8, precision: 12
    add_column :locations, :latitude, :float
    add_column :locations, :longitude, :float
  end
end
