class CreatePayslipRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :payslip_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.date :month
      t.integer :status

      t.timestamps
    end
  end
end
