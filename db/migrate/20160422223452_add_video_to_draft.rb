class AddVideoToDraft < ActiveRecord::Migration
  def change
    change_table :drafts do |t|
      t.references :video
    end
  end
end
