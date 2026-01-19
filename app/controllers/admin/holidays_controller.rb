module Admin
  class HolidaysController < ApplicationController
    before_action :ensure_admin

    def index
      @holidays = Holiday.order(:date)
    end

    def new
      @holiday = Holiday.new
    end

    def create
      @holiday = Holiday.new(holiday_params)
      if @holiday.save
        redirect_to admin_holidays_path, notice: "Holiday added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def holiday_params
      params.require(:holiday).permit(:name, :date)
    end
  end
end
