class AddUserToSetups < ActiveRecord::Migration
  def change
    change_table :setups do |t|
      t.references :user
    end
  end
end
