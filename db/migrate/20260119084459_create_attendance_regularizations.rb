class CreateAttendanceRegularizations < ActiveRecord::Migration[8.1]
  def change
    create_table :attendance_regularizations do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.datetime :check_in
      t.datetime :check_out
      t.text :reason
      t.integer :status

      t.timestamps
    end
  end
end
