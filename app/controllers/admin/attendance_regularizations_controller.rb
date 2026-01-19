module Admin
  class AttendanceRegularizationsController < ApplicationController
    before_action :ensure_admin

    def index
      @requests = AttendanceRegularization.pending.includes(:user)
    end

    def update
      request = AttendanceRegularization.find(params[:id])

      if params[:approve]
        apply_regularization(request)
        request.update!(status: :approved)
      else
        request.update!(status: :rejected)
      end
      AttendanceRegularizationMailer
        .notify_employee(request)
        .deliver_later

      redirect_to admin_attendance_regularizations_path,
        notice: "Request processed."
    end

    private

    def ensure_admin
      redirect_to root_path unless current_user.admin?
    end

    def apply_regularization(request)
      attendance = Attendance.find_or_initialize_by(
        user: request.user,
        date: request.date
      )

      worked_minutes =
        if request.check_in && request.check_out
          ((request.check_out - request.check_in) / 60).to_i
        end

      attendance.update!(
        check_in: request.check_in,
        check_out: request.check_out,
        worked_minutes: worked_minutes
      )
    end
  end
end
