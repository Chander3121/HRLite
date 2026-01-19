class AttendanceRegularization < ApplicationRecord
  belongs_to :user

  enum :status, {
    pending: 0,
    approved: 1,
    rejected: 2
  }

  validates :date, :reason, presence: true
    validate :date_within_allowed_window

  private

  def date_within_allowed_window
    if date.present? && date < 7.days.ago.to_date
      errors.add(:date, "can only be regularized within 7 days")
    end
  end
end
