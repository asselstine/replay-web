class DropTimeSeriesDataColumns < ActiveRecord::Migration
  def change
    remove_column :cameras, :time_series_data_id
    remove_column :activities, :time_series_data_id
  end
end
