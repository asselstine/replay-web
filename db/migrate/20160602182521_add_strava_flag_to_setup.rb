class AddStravaFlagToSetup < ActiveRecord::Migration
  def change
    change_table :setups do |t|
      t.boolean :use_strava
    end
  end
end
