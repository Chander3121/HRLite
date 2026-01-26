module Admin
  class PayrollsController < ApplicationController
    before_action :ensure_admin

    def index
      @users = User.employee
      @month =
        params[:month] ?
          Date.parse("#{params[:month]}-01") :
          Date.current.beginning_of_month

      @payrolls = Payroll
        .where(month: @month)
        .includes(user: [:active_salary_structure, :employee_profile])
    end

    # def create
    #   month = Date.parse("#{params[:month]}-01")

    #   User.employee.find_each do |user|
    #     PayrollCalculator.new(user, month).call
    #   rescue => e
    #     redirect_to admin_payrolls_path(month: month.strftime("%Y-%m")),
    #       alert: e.message
    #     return
    #   end

    #   redirect_to admin_payrolls_path(month: month.strftime("%Y-%m")),
    #     notice: "Payroll generated successfully."
    # end

    def create
      month = Date.parse(params[:month] + "-01").beginning_of_month

      if Payroll.where(month: month, locked: true).exists?
        redirect_to admin_payrolls_path(month: month.strftime("%Y-%m")),
          alert: "Payroll for #{month.strftime("%B %Y")} is locked and cannot be regenerated."
        return
      end

      skipped = 0
      generated = 0

      User.employee.find_each do |user|
        structure = user.active_salary_structure
        if structure.blank?
          skipped += 1
          next
        end

        Payrolls::CalculateMonthly.new(user: user, month: month).call
        generated += 1
      rescue => e
        Rails.logger.error("Payroll failed for #{user.id}: #{e.message}")
      end

      msg = "Payroll generated for #{generated} employees."
      msg += " Skipped #{skipped} (missing salary structure)." if skipped > 0

      redirect_to admin_payrolls_path(month: month.strftime("%Y-%m")), notice: msg
    end

    def show
      @payroll = Payroll.find(params[:id])
      @user = @payroll.user
      @structure = @user.salary_structures.active.order(effective_from: :desc).first
    end

    def download
      payroll = Payroll.find(params[:id])
      pdf = Pdfs::PayrollPdf.new(payroll).render
      send_data pdf,
        filename: "payslip-#{payroll.month.strftime('%Y-%m')}.pdf",
        type: "application/pdf",
        disposition: "attachment"
    end

    def lock_month
      month = Date.parse(params[:month] + "-01").beginning_of_month

      Payroll.where(month: month).update_all(locked: true)

      redirect_to admin_payrolls_path(month: month.strftime("%Y-%m")),
        notice: "Payroll locked for #{month.strftime("%B %Y")} ✅"
    end

    private

    def ensure_admin
      redirect_to root_path unless current_user.admin?
    end
  end
end
