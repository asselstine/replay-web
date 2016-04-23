class RemoveCameraFromVideo < ActiveRecord::Migration
  def change
    remove_reference :videos, :camera
  end
end
