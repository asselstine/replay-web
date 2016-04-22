class DropTimeSeriesData < ActiveRecord::Migration
  def change
    drop_table :time_series_data
  end
end
