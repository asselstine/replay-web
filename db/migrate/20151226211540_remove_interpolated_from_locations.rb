class RemoveInterpolatedFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :interpolated, :boolean, default: false
  end
end
