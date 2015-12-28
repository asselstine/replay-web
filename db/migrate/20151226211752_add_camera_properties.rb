class AddCameraProperties < ActiveRecord::Migration
  def change
    change_table :cameras do |t|
      t.boolean :static, default: true
      t.boolean :one_time, default: true
    end
  end
end
