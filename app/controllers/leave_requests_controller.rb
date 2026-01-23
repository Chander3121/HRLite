class LeaveRequestsController < ApplicationController
  before_action :ensure_employee
  before_action :set_leave_request, only: [:edit, :update]
  before_action :ensure_pending, only: [:edit, :update]

  def index
    @leaves = current_user.leave_requests.order(created_at: :desc)
  end

  def new
    @leave_request = current_user.leave_requests.new
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

  def edit;end

  def update
    if @leave_request.update(leave_request_params)
      redirect_to leave_requests_path, notice: "Leave request updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_leave_request
    @leave_request = current_user.leave_requests.find(params[:id])
  end

  def ensure_pending
    return if @leave_request.pending?

    redirect_to leave_requests_path, alert: "You can only edit pending leave requests."
  end

  def leave_params
    params.require(:leave_request).permit(
      :leave_type,
      :start_date,
      :end_date,
      :reason
    )
  end
end
