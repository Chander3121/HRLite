module Admin
  class DashboardsController < ApplicationController
    def show
      @employees_count = User.employee.count
      @today_attendance = Attendance.where(date: Date.current).count
      @pending_leaves = LeaveRequest.pending.count
      @payslip_requests_count = PayslipRequest.pending.count
      @attendance_regularize_requests = AttendanceRegularization.pending.count
    end
  end
end
