module Payrolls
  class Generator
    def initialize(month:)
      @month = month.beginning_of_month
    end

    def call
      employees = User.employee.includes(:salary_structures)

      generated = 0
      skipped = 0

      employees.find_each do |user|
        structure = user.salary_structures.active.order(effective_from: :desc).first

        if structure.nil?
          skipped += 1
          next
        end

        payroll = generate_for(user, structure)

        generated += 1 if payroll.persisted?
      end

      [generated, skipped]
    end

    private

    def generate_for(user, structure)
      # attendance calculation
      paid_days, unpaid_days, payable_days = attendance_summary(user)

      payable_days = payable_days.to_f
      paid_days = paid_days.to_f

      ratio =
        if payable_days <= 0
          0
        else
          (paid_days / payable_days).clamp(0, 1)
        end

      # salary structure totals
      monthly_earnings = structure.salary_components.earning.sum(&:calculated_amount).to_f
      monthly_deductions = structure.salary_components.deduction.sum(&:calculated_amount).to_f

      gross_payable = (monthly_earnings * ratio).round(2)

      # ✅ recommended: prorate deductions too
      deductions_payable = (monthly_deductions * ratio).round(2)

      net_payable = (gross_payable - deductions_payable).round(2)

      Payroll.create!(
        user: user,
        month: @month,

        paid_days: paid_days,
        unpaid_days: unpaid_days,
        payable_days: payable_days,

        gross_salary: monthly_earnings, # (keep compatibility)
        net_salary: net_payable,        # (keep compatibility)

        gross_monthly: monthly_earnings,
        gross_payable: gross_payable,
        deductions_monthly: monthly_deductions,
        deductions_payable: deductions_payable,
        net_payable: net_payable,
        payable_ratio: ratio
      )
    end

    def attendance_summary(user)
      start_date = @month.beginning_of_month
      end_date   = @month.end_of_month

      attendances = user.attendances.where(date: start_date..end_date)

      payable_days = attendances.where.not(status: "holiday").where.not(status: "weekend").count
      paid_days = attendances.where(status: "present").count
      unpaid_days = [payable_days - paid_days, 0].max

      [paid_days, unpaid_days, payable_days]
    end
  end
end
