class PayslipRequest < ApplicationRecord
  belongs_to :user

  enum :status, {
    pending: 0,
    generated: 1
  }

  has_one_attached :file
  validates :month, presence: true
  validates :user_id,
    uniqueness: {
      scope: :month,
      message: "payslip already requested for this month"
    }
end
