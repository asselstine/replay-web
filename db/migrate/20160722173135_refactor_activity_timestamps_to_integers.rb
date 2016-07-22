class RefactorActivityTimestampsToIntegers < ActiveRecord::Migration
  def change
    remove_column :activities, :timestamps, :datetime, array: true, default: []
    add_column :activities, :timestamps, :integer, array: true, default: []
  end
end
