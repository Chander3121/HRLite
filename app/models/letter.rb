class Letter < ApplicationRecord
  belongs_to :user
  belongs_to :letter_template

  has_one_attached :pdf

  enum :status, { drafted: 0, issued: 1 }
  enum :letter_type, LetterTemplate.letter_types

  validates :title, :letter_type, :issued_on, presence: true
end
