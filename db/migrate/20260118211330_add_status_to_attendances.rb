class AddStatusToAttendances < ActiveRecord::Migration[8.1]
  def change
    add_column :attendances, :status, :integer, default: 0, null: false
  end
end
