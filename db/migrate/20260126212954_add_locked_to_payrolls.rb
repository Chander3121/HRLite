class AddLockedToPayrolls < ActiveRecord::Migration[8.1]
  def change
    add_column :payrolls, :locked, :boolean, default: false, null: false
    add_index :payrolls, [:month, :locked]
  end
end
