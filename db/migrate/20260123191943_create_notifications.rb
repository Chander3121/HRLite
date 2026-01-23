class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :message
      t.string :url
      t.integer :kind
      t.datetime :read_at

      t.timestamps
    end
  end
end
