class AddTimesToUploads < ActiveRecord::Migration
  def change
    change_table :uploads do |t|
      t.datetime :start_at
      t.datetime :end_at
    end
  end
end
