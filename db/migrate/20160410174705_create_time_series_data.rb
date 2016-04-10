class CreateTimeSeriesData < ActiveRecord::Migration
  def change
    create_table :time_series_data do |t|
      t.references :trackable, polymorphic: true
      t.datetime :timestamps, array: true, default: []
      t.decimal :latitudes, scale: 8, precision: 12, array: true, default: []
      t.decimal :longitudes, scale: 8, precision: 12, array: true, default: []

      t.timestamps null: false
    end
  end
end
