class RemoveTrackableFromTimeSeriesData < ActiveRecord::Migration
  def change
    change_table :rides do |t|
      t.references :time_series_data
    end
    change_table :cameras do |t|
      t.references :time_series_data
    end
    remove_column :time_series_data, :trackable_id
    remove_column :time_series_data, :trackable_type
  end
end
