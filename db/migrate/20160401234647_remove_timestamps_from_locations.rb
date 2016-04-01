class RemoveTimestampsFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :created_at, :string
    remove_column :locations, :updated_at, :string
  end
end
