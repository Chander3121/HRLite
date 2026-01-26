class LetterTemplate < ApplicationRecord
  has_many :letters, dependent: :restrict_with_error

  enum :letter_type, {
    offer_letter: 0,
    promotion_letter: 1,
    increment_letter: 2,
    appreciation_letter: 3,
    award_certificate: 4,
    experience_letter: 5,
    relieving_letter: 6,
    warning_letter: 7,
    termination_letter: 8,
    salary_certificate: 9
  }

  validates :name, :letter_type, :body, presence: true
end
