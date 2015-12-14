class AddCameraToPhoto < ActiveRecord::Migration
  def change
    add_reference :photos, :camera
  end
end
