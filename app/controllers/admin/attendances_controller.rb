module Admin
  class AttendancesController < ApplicationController
    before_action :ensure_admin
    before_action :set_attendance, only: [ :edit, :update ]

    def index
      @users = User.employee.order(:email)
      @attendances = filtered_attendances
    end

    def edit
    end

    def update
      ActiveRecord::Base.transaction do
        check_in = parse_time(params[:attendance][:check_in])
        check_out = parse_time(params[:attendance][:check_out])

        worked_minutes =
          if check_in && check_out
            ((check_out - check_in) / 60).to_i
          end

        @attendance.update!(
          check_in: check_in,
          check_out: check_out,
          worked_minutes: worked_minutes
        )
      end

      redirect_to admin_attendances_path,
        notice: "Attendance updated successfully."
    rescue => e
      flash.now[:alert] = e.message
      render :edit, status: :unprocessable_entity
    end

    def export
      attendances = filtered_attendances

      csv_data = CSV.generate(headers: true) do |csv|
        csv << [ "Employee Email", "Date", "Check In", "Check Out", "Worked Hours" ]

        attendances.each do |a|
          csv << [
            a.user.email,
            a.date,
            a.check_in&.strftime("%H:%M"),
            a.check_out&.strftime("%H:%M"),
            worked_hours(a)
          ]
        end
      end

      send_data csv_data,
        filename: "attendance-#{Date.today}.csv"
    end

    private

    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    def parse_time(value)
      return nil if value.blank?
      Time.zone.parse(value)
    end

    def filtered_attendances
      scope = Attendance.includes(:user).order(date: :desc)

      if params[:user_id].present?
        scope = scope.where(user_id: params[:user_id])
      end

      if params[:date].present?
        parsed_date = Date.parse(params[:date]) rescue nil
        scope = scope.where(date: parsed_date) if parsed_date
      end

      scope
    end

    def worked_hours(attendance)
      return "-" unless attendance.worked_minutes
      (attendance.worked_minutes / 60.0).round(2)
    end
  end
end
