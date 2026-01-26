module SalaryStructures
  class CalculateTotals
    def initialize(structure)
      @structure = structure
    end

    def call
      return empty_totals if @structure.blank?

      earnings = 0.0
      deductions = 0.0

      @structure.salary_components.each do |c|
        amt = c.computed_amount.to_f
        if c.earning?
          earnings += amt
        else
          deductions += amt
        end
      end

      {
        gross_salary: earnings.round(2),
        total_deductions: deductions.round(2),
        net_salary: (earnings - deductions).round(2)
      }
    end

    private

    def empty_totals
      { gross_salary: 0.0, total_deductions: 0.0, net_salary: 0.0 }
    end
  end
end
