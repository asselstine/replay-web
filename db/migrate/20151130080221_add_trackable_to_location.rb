class AddTrackableToLocation < ActiveRecord::Migration
  def change
    add_reference :locations, :trackable, polymorphic: true
    remove_reference :locations, :ride
  end
end
