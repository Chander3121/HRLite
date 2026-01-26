class CreateLetterTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :letter_templates do |t|
      t.string :name, null: false
      t.integer :letter_type, null: false
      t.text :body, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :letter_templates, [:letter_type, :active]
  end
end
