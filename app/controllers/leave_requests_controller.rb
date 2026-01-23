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
    if @leave_request.update(leave_params)
      notify_admins!(
        title: "Leave Request Updated",
        message: "#{current_user.employee_profile.first_name} edited a leave request (#{@leave_request.leave_type.titleize})",
        url: admin_leave_requests_path,
        kind: :leave_request
      )
      redirect_to leave_requests_path, notice: "Leave request updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    leave = current_user.leave_requests.find(params[:id])

    unless leave.pending?
      redirect_to leave_requests_path, alert: "Only pending leave requests can be cancelled."
      return
    end

    leave.update!(status: :cancelled)

    redirect_to leave_requests_path, notice: "Leave request cancelled."
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
