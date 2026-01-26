class AddBreakdownToPayrolls < ActiveRecord::Migration[8.1]
  def change
    change_table :payrolls, bulk: true do |t|
      t.decimal :gross_monthly, precision: 12, scale: 2
      t.decimal :gross_payable, precision: 12, scale: 2

      t.decimal :deductions_monthly, precision: 12, scale: 2
      t.decimal :deductions_payable, precision: 12, scale: 2

      t.decimal :net_payable, precision: 12, scale: 2
      t.decimal :payable_ratio, precision: 6, scale: 4
    end
  end
end
