class Holiday < ApplicationRecord
  validates :name, :date, presence: true

  scope :upcoming, -> { where("date >= ?", Date.current).order(:date) }
  scope :current_year, -> {
    where(date: Date.current.beginning_of_year..Date.current.end_of_year)
      .order(:date)
  }
end
