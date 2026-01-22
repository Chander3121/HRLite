class CreateAdminPreferences < ActiveRecord::Migration[8.1]
  def change
    create_table :admin_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.string :key
      t.datetime :last_seen_at

      t.timestamps
    end
  end
end
