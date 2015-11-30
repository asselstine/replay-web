class Camera < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
      t.decimal :lat, null: false
      t.decimal :long, null: false

      t.timestamps
    end
  end
end
