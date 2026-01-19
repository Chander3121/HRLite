class Attendance < ApplicationRecord
  attribute :status, :integer

  belongs_to :user

  enum :status, {
    full_day: 0,
    short_working: 1,
    half_day: 2,
    absent: 3,
    holiday: 4,
    weekly_off: 5
  }

  validates :date, presence: true
  validates :user_id, uniqueness: { scope: :date }

  after_commit :deduct_half_day_leave, on: :update
  before_validation :mark_weekly_off_or_holiday, on: :create
  before_save :calculate_status, if: :working_day?

  private

  def mark_weekly_off_or_holiday
    if weekly_off_day?
      self.status = :weekly_off
    elsif Holiday.exists?(date: date)
      self.status = :holiday
    end
  end

  def weekly_off_day?
    date.saturday? || date.sunday?
  end

  def working_day?
    !weekly_off? && !holiday?
  end

  def calculate_status
    return if check_in.blank? || check_out.blank?

    hours = worked_minutes.to_f / 60

    self.status =
      if hours >= 8
        :full_day
      elsif hours >= 4
        :short_working
      else
        :half_day
      end
  end

  def deduct_half_day_leave
    return unless saved_change_to_status?
    return unless half_day?

    balance = user.leave_balances.find_by(leave_type: "paid")
    return unless balance
    return if balance.used + 0.5 > balance.total

    balance.increment!(:used, 0.5)
  end
end
