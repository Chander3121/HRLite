class CreateLeaveBalances < ActiveRecord::Migration[8.1]
  def change
    create_table :leave_balances do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :leave_type, null: false
      t.integer :total, default: 0, null: false
      t.integer :used, default: 0, null: false

      t.timestamps
    end

    add_index :leave_balances, [:user_id, :leave_type], unique: true
  end
end
