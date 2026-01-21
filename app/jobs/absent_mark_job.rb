class AbsentMarkJob < ApplicationJob
  queue_as :default

  def perform
    today = Date.current

    # Safety guards
    return if today.saturday? || today.sunday?
    return if Holiday.exists?(date: today)

    User.employee.find_each do |user|
      next if user.employee_profile&.joining_date.present? &&
              today < user.employee_profile.joining_date

      Attendance.find_or_create_by(user: user, date: today) do |attendance|
        attendance.status = "absent"
        attendance.check_in = nil
        attendance.check_out = nil
      end
    end
  end
end
