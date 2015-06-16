class AddRideToLocationSample < ActiveRecord::Migration
  def change
    add_reference :location_samples, :ride, index: true, foreign_key: true
  end
end
