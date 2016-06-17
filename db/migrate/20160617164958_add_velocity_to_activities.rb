class AddVelocityToActivities < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.decimal :velocities, default: [], array: true
    end
  end
end
