class RenameRideToActivity < ActiveRecord::Migration
  def change
    rename_table :rides, :activities
  end
end
