class PayrollsController < ApplicationController
  before_action :ensure_employee

  def index
    @payrolls = current_user.payrolls.order(month: :desc)
  end

  def show
    @payroll = current_user.payrolls.find(params[:id])
    @structure = current_user.salary_structures.active.order(effective_from: :desc).first
  end

  def download
    @payroll = current_user.payrolls.find(params[:id])
    pdf = PayrollPdf.new(@payroll).render

    send_data pdf,
      filename: "payslip-#{@payroll.month.strftime('%Y-%m')}.pdf",
      type: "application/pdf",
      disposition: "attachment"
  end

  private

  def ensure_employee
    redirect_to root_path, alert: "Not authorized" unless current_user&.employee?
  end
end
