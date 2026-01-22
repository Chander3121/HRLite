class LeaveRequest < ApplicationRecord
  belongs_to :user

  enum :leave_type, { sick: 0, casual: 1, paid: 2 }
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validates :start_date, :end_date, presence: true

  after_create_commit do
    broadcast_prepend_to "admin_toasts",
      target: "toast-container",
      partial: "shared/toast",
      locals: {
        title: "New Leave Request",
        message: "#{user.employee_profile.first_name} requested leave",
        icon: "paper-airplane",
        url: Rails.application.routes.url_helpers.admin_leave_requests_path
      }
  end
end
