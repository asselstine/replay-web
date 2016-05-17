class AddUserToVideo < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.references :user, index: true, foreign_key: true
    end
  end
end
