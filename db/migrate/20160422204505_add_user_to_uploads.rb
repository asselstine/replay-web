class AddUserToUploads < ActiveRecord::Migration
  def change
    change_table :uploads do |t|
      t.references :user
    end
  end
end
