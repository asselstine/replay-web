class AddNameToCameras < ActiveRecord::Migration
  def change
    add_column :cameras, :name, :string
  end
end
