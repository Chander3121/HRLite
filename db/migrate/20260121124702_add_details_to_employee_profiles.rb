class AddDetailsToEmployeeProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :employee_profiles, :emp_id, :string
    add_column :employee_profiles, :phone, :string
    add_column :employee_profiles, :dob, :date
    add_column :employee_profiles, :age, :integer
    add_column :employee_profiles, :gender, :integer
    add_column :employee_profiles, :blood_group, :string
    add_column :employee_profiles, :address, :text
    add_column :employee_profiles, :emergency_contact_name, :string
    add_column :employee_profiles, :emergency_contact_phone, :string
    add_column :employee_profiles, :employment_type, :integer
    add_column :employee_profiles, :status, :integer

    add_index :employee_profiles, :emp_id, unique: true
  end
end
