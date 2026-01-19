class CreatePayrolls < ActiveRecord::Migration[8.1]
  def change
    create_table :payrolls do |t|
      t.references :user, null: false, foreign_key: true
      t.date :month
      t.decimal :gross_salary, precision: 10, scale: 2
      t.decimal :paid_days, precision: 5, scale: 2
      t.decimal :unpaid_days, precision: 5, scale: 2
      t.decimal :net_salary, precision: 10, scale: 2
      t.decimal :payable_days

      t.timestamps
    end
  end
end
