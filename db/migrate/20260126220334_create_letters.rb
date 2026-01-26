class CreateLetters < ActiveRecord::Migration[8.1]
  def change
    create_table :letters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :letter_template, null: false, foreign_key: true

      t.string :title, null: false
      t.integer :letter_type, null: false
      t.integer :status, default: 0, null: false
      t.date :issued_on, null: false

      t.jsonb :metadata, default: {}, null: false

      t.timestamps
    end

    add_index :letters, [:user_id, :letter_type]
    add_index :letters, :issued_on
  end
end
