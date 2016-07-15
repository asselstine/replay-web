class AddNameToDraft < ActiveRecord::Migration
  def change
    change_table :drafts do |t|
      t.string :name
    end
  end
end
