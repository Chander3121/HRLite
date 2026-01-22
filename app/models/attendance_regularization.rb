class AttendanceRegularization < ApplicationRecord
  belongs_to :user

  enum :status, {
    pending: 0,
    approved: 1,
    rejected: 2
  }

  validates :date, :reason, presence: true
  validate :date_within_allowed_window

  after_create_commit do
    broadcast_prepend_to "admin_toasts",
      target: "toast-container",
      partial: "shared/toast",
      locals: {
        title: "Attendance Regularization",
        message: "#{user.employee_profile.first_name} submitted a regularization request",
        icon: "bookmark-slash",
        url: Rails.application.routes.url_helpers.admin_attendance_regularizations_path
      }
  end

  private

  def date_within_allowed_window
    if date.present? && date < 7.days.ago.to_date
      errors.add(:date, "can only be regularized within 7 days")
    end
  end
end
