class CreateStravaAccounts < ActiveRecord::Migration
  def change
    create_table :strava_accounts do |t|
      t.string :uid
      t.string :token
      t.string :username
      t.references :user

      t.timestamps null: false
    end
  end
end
