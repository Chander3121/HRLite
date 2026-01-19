module Admin
  class AttendanceSummariesController < ApplicationController
    before_action :ensure_admin

    def index
      @users = User.employee.order(:email)

      @month =
        params[:month] ?
          Date.parse("#{params[:month]}-01") :
          Date.current.beginning_of_month

      @summaries = build_summaries
    end

    private

    def build_summaries
      summaries = {}

      start_date = @month.beginning_of_month
      end_date   = @month.end_of_month

      User.employee.find_each do |user|
        records = user.attendances
                      .where(date: start_date..end_date)

        summaries[user.id] = {
          present: records.presence&.count,
          short_working: records.short_working.count,
          half_day: records.half_day.count,
          weekly_off: records.weekly_off.count,
          holiday: records.holiday.count,
          absent: records.absent.count
        }
      end

      summaries
    end
  end
end
