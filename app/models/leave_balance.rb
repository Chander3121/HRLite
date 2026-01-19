class LeaveBalance < ApplicationRecord
  belongs_to :user

  enum :leave_type, { paid: 0, sick: 1, casual: 2 }

  def remaining
    total - used
  end
end
