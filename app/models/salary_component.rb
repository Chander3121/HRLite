class SalaryComponent < ApplicationRecord
  belongs_to :salary_structure

  enum :component_type, { earning: 0, deduction: 1 }
  enum :calculation_mode, { fixed: 0, percent: 1 }

  validates :name, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  def calculated_amount
    return amount.to_f if fixed?

    base = salary_structure.salary_components.find_by(name: percent_of)&.amount.to_f
    ((base * amount.to_f) / 100.0).round(2)
  end
end
