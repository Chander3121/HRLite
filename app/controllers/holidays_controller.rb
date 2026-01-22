class HolidaysController < ApplicationController
  def index
    year = Date.current.year

    @holidays = Holiday
      .where(date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
      .index_by(&:date)
  end
end
