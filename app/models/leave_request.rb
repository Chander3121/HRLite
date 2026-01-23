class LeaveRequest < ApplicationRecord
  belongs_to :user

  enum :leave_type, { sick: 0, casual: 1, paid: 2 }
  enum :status, { pending: 0, approved: 1, rejected: 2, cancelled: 3 }

  validates :start_date, :end_date, presence: true

  after_create_commit do
    # 1) create DB notification for admin users
    User.admin.find_each do |admin|
      Notification.create!(
        user: admin,
        kind: :leave_request,
        title: "New Leave Request",
        message: "#{user.employee_profile.first_name} requested #{leave_type.titleize} leave",
        url: Rails.application.routes.url_helpers.admin_leave_requests_path
      )
    end

    # 2) real-time toast for admins
    broadcast_prepend_to "admin_toasts",
      target: "toast-container",
      partial: "shared/toast",
      locals: {
        title: "New Leave Request",
        message: "#{user.employee_profile.first_name} requested #{leave_type.titleize} leave",
        icon: "paper-airplane",
        url: Rails.application.routes.url_helpers.admin_leave_requests_path
      }
  end
end
