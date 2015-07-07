class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.references :user

      t.timestamps null: false
    end
  end
end
