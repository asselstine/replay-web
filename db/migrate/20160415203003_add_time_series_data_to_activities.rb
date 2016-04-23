class AddTimeSeriesDataToActivities < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.datetime :timestamps, array: true, default: []
      t.decimal :latitudes, scale: 8, precision: 12, array: true, default: []
      t.decimal :longitudes, scale: 8, precision: 12, array: true, default: []
    end
  end
end
