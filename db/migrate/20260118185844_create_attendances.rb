class CreateAttendances < ActiveRecord::Migration[8.1]
  def change
    create_table :attendances do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.datetime :check_in
      t.datetime :check_out
      t.integer :worked_minutes

      t.timestamps
    end
  end
end
