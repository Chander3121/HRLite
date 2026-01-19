class CreateEmployeeProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :employee_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :designation
      t.date :joining_date
      t.decimal :salary, precision: 10, scale: 2

      t.timestamps
    end
  end
end
