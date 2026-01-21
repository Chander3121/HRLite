class AddIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :attendances, [ :user_id, :date ], unique: true
    add_index :leave_requests, :status
  end
end
