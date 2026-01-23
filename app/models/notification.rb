class Notification < ApplicationRecord
  belongs_to :user

  enum :kind, {
    leave_request: 0,
    payslip_request: 1,
    regularization_request: 2,
    general: 3
  }

  scope :recent, -> { order(created_at: :desc) }
  scope :unread, -> { where(read_at: nil) }
end
