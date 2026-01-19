class LeaveRequest < ApplicationRecord
  belongs_to :user

  enum :leave_type, { sick: 0, casual: 1, paid: 2 }
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validates :start_date, :end_date, presence: true
end
