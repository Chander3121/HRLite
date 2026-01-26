class CreateSalaryComponents < ActiveRecord::Migration[8.1]
  def change
    create_table :salary_components do |t|
      t.references :salary_structure, null: false, foreign_key: true

      t.string :name, null: false
      t.integer :component_type, null: false # earning / deduction
      t.integer :calculation_mode, null: false, default: 0 # fixed / percent
      t.decimal :amount, precision: 12, scale: 2, null: false, default: 0

      # if percent calculation
      t.string :percent_of # BASIC / GROSS

      t.timestamps
    end
  end
end
