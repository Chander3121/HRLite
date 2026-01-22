class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_employee

  def index
    @month =
      params[:month] ?
        Date.parse("#{params[:month]}-01") :
        Date.current.beginning_of_month

    @start_date = [@month.beginning_of_month, current_user.employee_profile.joining_date].max
    @end_date   = @month.end_of_month

    @records = current_user.attendances
                           .where(date: @start_date..@end_date)
                           .index_by(&:date)

    build_summary
  end

  def check_in
    today = Date.current

    if today.saturday? || today.sunday?
      redirect_to dashboard_path, alert: "Today is a weekly off."
      return
    end

    if Holiday.exists?(date: today)
      redirect_to dashboard_path, alert: "Today is a holiday."
      return
    end

    attendance = current_user.attendances.find_or_initialize_by(date: today)

    if attendance.check_in.present?
      redirect_to dashboard_path, alert: "Already checked in."
    else
      attendance.check_in = Time.current
      attendance.status = "present"
      attendance.save!
      redirect_to dashboard_path, notice: "Checked in successfully."
    end
  end

  def check_out
    attendance = current_user.attendances.find_by(date: Date.current)

    if attendance.nil? || attendance.check_in.nil?
      redirect_to dashboard_path, alert: "Please check in first."
    elsif attendance.check_out.present?
      redirect_to dashboard_path, alert: "You already checked out."
    else
      attendance.update!(
        check_out: Time.current,
        worked_minutes: ((Time.current - attendance.check_in) / 60).to_i
      )

      redirect_to dashboard_path, notice: "Checked out successfully."
    end
  end

  private

  def build_summary
    attendances = @records.values
    @summary = {
      present: attendances.count { |a| ["full_day", "half_day", "short_working"].include? a.status },
      short_working: attendances.count { |a| a.short_working? },
      half_day: attendances.count { |a| a.half_day? },
      absent: attendances.count { |a| a.absent? },
      holiday: attendances.count { |a| a.holiday? },
      weekly_off: attendances.count { |a| a.weekly_off? }
    }

    @total_working_days =
      (@start_date..@end_date).count do |date|
        !date.saturday? &&
        !date.sunday? &&
        !Holiday.exists?(date: date)
      end
  end
end
