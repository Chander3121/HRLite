class DashboardsController < ApplicationController

  def show
    if current_user.admin?
      redirect_to admin_dashboard_path
    else
      @today_attendance = current_user.attendances.find_by(date: Date.current)
      @pending_leaves = current_user.leave_requests.pending.count
    end
  end

  def birthdays
    profiles = EmployeeProfile
      .joins(:user)
      .where.not(dob: nil)
      .where(users: { role: :employee })
      .with_attached_profile_picture

    today = Date.current

    @today_birthdays = profiles.select do |p|
      p.dob.month == today.month && p.dob.day == today.day
    end

    @upcoming_birthdays = profiles.select do |p|
      birthday_this_year = Date.new(today.year, p.dob.month, p.dob.day)
      birthday_this_year > today
    end.sort_by { |p| [p.dob.month, p.dob.day] }
  end
end
