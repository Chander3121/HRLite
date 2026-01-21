class EmployeeProfile < ApplicationRecord
  belongs_to :user
  has_one_attached :profile_picture

  validates :first_name, :joining_date, presence: true
  validates :emp_id, presence: true, uniqueness: true
  validates :phone, length: { minimum: 10 }, allow_blank: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_validation :assign_emp_id, on: :create
  before_save :calculate_age, if: -> { dob.present? }

  enum :gender, {
    male: 0,
    female: 1,
    other: 2
  }

  enum :employment_type, {
    full_time: 0,
    part_time: 1,
    intern: 2,
    contract: 3
  }

  enum :status, {
    active: 0,
    inactive: 1,
    resigned: 2
  }

  private

  def assign_emp_id
    return if emp_id.present?

    last_id = EmployeeProfile
      .where("emp_id LIKE ?", "EMP-%")
      .order(:created_at)
      .pluck(:emp_id)
      .last

    next_number =
      if last_id.present?
        last_id.split("-").last.to_i + 1
      else
        1
      end

    self.emp_id = format("EMP-%04d", next_number)
  end

  def calculate_age
    self.age = Date.current.year - dob.year
    self.age -= 1 if Date.current < dob + age.years
  end
end
