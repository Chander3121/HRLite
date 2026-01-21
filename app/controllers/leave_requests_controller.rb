class LeaveRequestsController < ApplicationController
  before_action :ensure_employee

  layout "dashboard"

  def index
    @leaves = current_user.leave_requests.order(created_at: :desc)
  end

  def new
    @leave = LeaveRequest.new
  end

  def create
    @leave = current_user.leave_requests.new(leave_params)
    @leave.status = :pending

    days = (@leave.end_date - @leave.start_date).to_i + 1
    balance = current_user.leave_balances.find_by(
      leave_type: @leave.leave_type
    )

    if balance.remaining < days
      redirect_to new_leave_request_path,
        alert: "Not enough leave balance."
      return
    end

    if @leave.save
      redirect_to leave_requests_path, notice: "Leave applied successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def leave_params
    params.require(:leave_request).permit(
      :leave_type,
      :start_date,
      :end_date,
      :reason
    )
  end
end
