class AddStravaFlagToSetup < ActiveRecord::Migration
  def change
    change_table :setups do |t|
      t.integer :location, default: Setup.locations[:strava], null: false
    end
  end
end
