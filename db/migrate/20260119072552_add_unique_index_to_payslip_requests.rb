class AddUniqueIndexToPayslipRequests < ActiveRecord::Migration[8.1]
  def change
    add_index :payslip_requests,
              [ :user_id, :month ],
              unique: true
  end
end
