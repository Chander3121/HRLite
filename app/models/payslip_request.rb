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

  after_create_commit do
    broadcast_prepend_to "admin_toasts",
      target: "toast-container",
      partial: "shared/toast",
      locals: {
        title: "Payslip Requested",
        message: "#{user.employee_profile.first_name} requested a payslip",
        icon: "document-text",
        url: Rails.application.routes.url_helpers.admin_payslip_requests_path
      }
  end
end
