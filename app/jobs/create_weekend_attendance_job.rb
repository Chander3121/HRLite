class CreateWeekendAttendanceJob < ApplicationJob
  queue_as :default

  def perform
    saturday = Date.current.beginning_of_week + 5.days
    sunday   = saturday + 1.day

    User.employee.find_each do |user|
      create_attendance_for_date(user, saturday)
      create_attendance_for_date(user, sunday)
    end
  end

  private

  def create_attendance_for_date(user, date)
    Attendance.find_or_create_by(user: user, date: date) do |attendance|
      attendance.check_in = nil
      attendance.check_out = nil
      attendance.status = "weekly_off"
    end
  end
end
