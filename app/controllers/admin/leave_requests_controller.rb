class Admin::LeaveRequestsController < ApplicationController
  before_action :ensure_admin
  after_action -> { mark_seen("leave_requests") }, only: :index

  def index
    @leaves = LeaveRequest.pending.includes(:user)
  end

  def approve
    leave = LeaveRequest.find(params[:id])

    ActiveRecord::Base.transaction do
      days = (leave.end_date - leave.start_date).to_i + 1

      balance = leave.user.leave_balances.find_by!(
        leave_type: leave.leave_type
      )

      if balance.remaining < days
        redirect_to admin_leave_requests_path,
          alert: "Insufficient leave balance."
        return
      end

      balance.update!(used: balance.used + days)
      if leave.update(status: :approved)
        # notify employee
        notify_user!(
          user: leave.user,
          title: "Leave Request #{ leave.status.titleize }",
          message: "Your #{ leave.leave_type.titleize } leave (#{leave.start_date&.strftime("%d %b %Y")} to #{leave.end_date&.strftime("%d %b %Y")}) was #{ leave.status.titleize.downcase }.",
          url: leave_requests_path,
          kind: :leave_request,
          icon: "paper-airplane"
        )
      end
    end

    LeaveMailer.status_update(leave).deliver_later

    redirect_to admin_leave_requests_path,
      notice: "Leave approved and balance updated."
  end

  def reject
    leave.update!(status: :rejected)

    LeaveMailer.status_update(leave).deliver_later

    redirect_to admin_leave_requests_path, alert: "Leave rejected and employee notified."
  end

  private

  def leave
    @leave ||= LeaveRequest.find(params[:id])
  end
end
