class EmployeeProfile < ApplicationRecord
  belongs_to :user

  validates :first_name, :joining_date, presence: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
