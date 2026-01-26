class SalaryStructure < ApplicationRecord
  belongs_to :user
  has_many :salary_components, dependent: :destroy

  accepts_nested_attributes_for :salary_components, allow_destroy: true

  enum :status, { active: 0, archived: 1 }

  validates :effective_from, presence: true

  validate :only_one_active_structure, if: :active?

  def total_earnings
    salary_components.earning.sum(&:computed_amount)
  end

  def total_deductions
    salary_components.deduction.sum(&:computed_amount)
  end

  def gross_salary
    total_earnings
  end

  def net_salary
    gross_salary - total_deductions
  end

  private

  def only_one_active_structure
    return unless user

    existing = SalaryStructure.where(user_id: user_id, status: :active).where.not(id: id)
    errors.add(:status, "already has an active structure") if existing.exists?
  end
end
