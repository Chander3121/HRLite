class PayrollCalculator
  def initialize(user, month)
    @user = user
    @month = month.beginning_of_month
  end

  def call
    attendances = fetch_attendance
    @profile = @user.employee_profile
    raise "Salary not set for #{@user.email}" if @profile.nil? || @profile.salary.blank?

    salary = @profile.salary.to_f

    total_working_days = working_days_in_month
    per_day_salary = salary / total_working_days

    paid_days = calculate_paid_days(attendances)
    unpaid_days = total_working_days - paid_days

    net_salary = paid_days * per_day_salary

    Payroll.create!(
      user: @user,
      month: @month,
      gross_salary: salary,
      paid_days: paid_days,
      unpaid_days: unpaid_days,
      net_salary: net_salary.round(2)
    )
  end

  private

  def fetch_attendance
    @user.attendances.where(
      date: @month.beginning_of_month..@month.end_of_month
    )
  end

  def working_days_in_month
    start_date = [@month.beginning_of_month, @profile.joining_date].max
    end_date = @month.end_of_month

    (start_date..end_date).count do |date|
      !date.saturday? &&
      !date.sunday? &&
      !Holiday.exists?(date: date)
    end
  end

  def calculate_paid_days(attendances)
    paid = 0.0

    attendances.each do |attendance|
      case attendance.status
      when "present", "short_working"
        paid += 1
      when "half_day"
        paid += 0.5
      when "holiday", "weekly_off"
        paid += 1
      when "absent"
        paid += 0
      end
    end

    paid
  end
end
