class AddRideToEdit < ActiveRecord::Migration
  def change
    add_reference :edits, :ride, index: true, foreign_key: true
  end
end
