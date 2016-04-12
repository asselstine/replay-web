class AddUserToCamera < ActiveRecord::Migration
  def change
    change_table :cameras do |t|
      t.references :user
    end
  end
end
