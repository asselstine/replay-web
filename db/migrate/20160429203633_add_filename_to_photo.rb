class AddFilenameToPhoto < ActiveRecord::Migration
  def change
    change_table :photos do |t|
      t.string :filename
    end
  end
end
