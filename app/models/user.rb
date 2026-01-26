class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { employee: 0, admin: 1 }

  has_one :employee_profile, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  has_many :leave_balances, dependent: :destroy
  has_many :payslip_requests, dependent: :destroy
  has_many :attendance_regularizations, dependent: :destroy
  has_many :admin_preferences, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :salary_structures, dependent: :destroy
  has_one :active_salary_structure,
    -> { where(status: :active).order(effective_from: :desc) },
    class_name: "SalaryStructure"
  has_many :payrolls, dependent: :destroy
  has_many :letters, dependent: :destroy
  has_many :letter_templates, through: :letters

  after_create :setup_leave_balances, if: :employee?

  private

  def setup_leave_balances
    LeaveBalance.leave_types.each do |type, _|
      default_days =
        case type
        when "paid" then 12
        when "sick" then 6
        when "casual" then 6
        end

      leave_balances.create!(
        leave_type: type,
        total: default_days
      )
    end
  end
end
