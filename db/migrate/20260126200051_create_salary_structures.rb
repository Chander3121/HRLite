class CreateSalaryStructures < ActiveRecord::Migration[8.1]
  def change
    create_table :salary_structures do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.date :effective_from, null: false
      t.text :notes

      t.timestamps
    end

    add_index :salary_structures, [:user_id, :status]
  end
end
