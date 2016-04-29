class AddDefaultsToLatitudeLongitude < ActiveRecord::Migration
  def change
    change_column_default :setups, :latitude, 49.256711
    change_column_default :setups, :longitude, -123.114225
  end
end
