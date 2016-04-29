class AddSourceUrlToPhoto < ActiveRecord::Migration
  def change
    change_table :photos do |t|
      t.string :source_url
    end
  end
end
