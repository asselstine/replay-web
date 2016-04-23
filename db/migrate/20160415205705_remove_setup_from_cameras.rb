class RemoveSetupFromCameras < ActiveRecord::Migration
  def change
    remove_column :cameras, :range_m
    remove_column :cameras, :static
    remove_column :cameras, :one_time
  end
end
