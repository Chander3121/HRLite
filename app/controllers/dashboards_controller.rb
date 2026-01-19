class DashboardsController < ApplicationController
  def show
    if current_user.admin?
      redirect_to admin_dashboard_path
    else
      @today_attendance = current_user.attendances.find_by(date: Date.current)
      @pending_leaves = current_user.leave_requests.pending.count
    end
  end
end
