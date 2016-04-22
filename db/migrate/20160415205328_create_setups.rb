class CreateSetups < ActiveRecord::Migration
  def change
    create_table :setups do |t|
      t.references :camera
      t.decimal "range_m", precision: 6, scale: 2, default: 16.0
      t.datetime :timestamp
      t.decimal :latitude, scale: 8, precision: 12
      t.decimal :longitude, scale: 8, precision: 12

      t.timestamps null: false
    end
  end
end
