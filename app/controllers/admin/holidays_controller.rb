module Admin
  class HolidaysController < ApplicationController
    before_action :ensure_admin

    def index
      @holidays = Holiday.current_year
      @holiday = Holiday.new
    end

    def create
      @holiday = Holiday.new(holiday_params)
      if @holiday.save
        redirect_to admin_holidays_path, notice: "Holiday added."
      else
        @holidays = Holiday.current_year
        render :index, status: :unprocessable_entity
      end
    end

    def destroy
      holiday = Holiday.find(params[:id])
      holiday.destroy
      redirect_to admin_holidays_path, notice: "Holiday removed."
    end

    private

    def holiday_params
      params.require(:holiday).permit(:name, :date)
    end
  end
end
