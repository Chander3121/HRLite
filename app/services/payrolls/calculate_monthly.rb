module Payrolls
  class CalculateMonthly
    def initialize(user:, month:)
      @user = user
      @month = month.beginning_of_month
    end

    def call
      structure = @user.active_salary_structure
      raise "Salary structure missing for employee" if structure.blank?

      totals = SalaryStructures::CalculateTotals.new(structure).call

      gross_salary = totals[:gross_salary]
      net_salary   = totals[:net_salary]

      attendances = fetch_attendance

      total_working_days = working_days_in_month
      paid_days = calculate_paid_days(attendances)
      unpaid_days = (total_working_days - paid_days).clamp(0, total_working_days)

      per_day_salary = gross_salary / [total_working_days, 1].max
      final_net_salary = (net_salary / [total_working_days, 1].max) * paid_days

      Payroll.create!(
        user: @user,
        month: @month,
        gross_salary: gross_salary.round(2),
        net_salary: final_net_salary.round(2),
        paid_days: paid_days.round(2),
        unpaid_days: unpaid_days.round(2),
        payable_days: total_working_days
      )
    end

    private

    def fetch_attendance
        binding.pry
        @user.attendances.where(date: @month..@month.end_of_month)
    end

    def working_days_in_month
      # excludes weekends & holidays
      total = 0
      (@month..@month.end_of_month).each do |date|
        next if date.saturday? || date.sunday?
        next if Holiday.exists?(date: date)
        total += 1
      end
      total
    end

    def calculate_paid_days(attendances)
      # ✅ Define paid status mapping
      # present => 1
      # half_day => 0.5
      # short_leave => 1
      # absent => 0
      # holiday/weekend => excluded by working_days_in_month
      paid = 0.0

      attendances.each do |a|
        case a.status.to_s
        when "present"
          paid += 1
        when "half_day"
          paid += 0.5
        when "short_leave"
          paid += 1
        else
          paid += 0
        end
      end

      paid
    end
  end
end
