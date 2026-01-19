class PayslipRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_employee

  def index
    @requests = current_user.payslip_requests.order(month: :desc)
  end

  def new
    @request = PayslipRequest.new
  end

  def create
  	month = Date.parse("#{request_params[:month]}-01")

    if current_user.payslip_requests.exists?(month: month)
      redirect_to payslip_requests_path,
        alert: "You have already requested a payslip for this month."
      return
    end

    @request = current_user.payslip_requests.new(
	    month: month,
	    status: :pending
	  )

	  if @request.save
	    redirect_to payslip_requests_path,
	      notice: "Payslip request submitted."
	  else
	    render :new, status: :unprocessable_entity
	  end
  end

  private

  def request_params
    params.require(:payslip_request).permit(:month)
  end
end
