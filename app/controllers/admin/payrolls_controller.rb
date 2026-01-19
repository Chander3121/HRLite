module Admin
  class PayrollsController < ApplicationController
    before_action :ensure_admin

    def index
      @users = User.employee
      @month =
        params[:month] ?
          Date.parse("#{params[:month]}-01") :
          Date.current.beginning_of_month

      @payrolls = Payroll.where(month: @month)
    end

    def create
      month = Date.parse("#{params[:month]}-01")

      User.employee.find_each do |user|
        PayrollCalculator.new(user, month).call
      rescue => e
        redirect_to admin_payrolls_path(month: month.strftime("%Y-%m")),
          alert: e.message
        return
      end

      redirect_to admin_payrolls_path(month: month.strftime("%Y-%m")),
        notice: "Payroll generated successfully."
    end

    private

    def ensure_admin
      redirect_to root_path unless current_user.admin?
    end
  end
end
