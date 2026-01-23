class AttendanceRegularizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_employee

  before_action :set_regularization, only: [:edit, :update]
  before_action :ensure_pending, only: [:edit, :update]

  def index
    @requests = current_user.attendance_regularizations.order(date: :desc)
  end

  def new
    @regularization = current_user.attendance_regularizations.new
  end

  def create
    @request = current_user.attendance_regularizations.new(request_params)
    @request.status = :pending

    if @request.save
      AttendanceRegularizationMailer
        .notify_admin(@request)
        .deliver_later

      redirect_to attendance_regularizations_path,
        notice: "Regularization request submitted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @regularization.update(request_params)
      notify_admins!(
        title: "Regularization Updated",
        message: "#{current_user.employee_profile.first_name} edited attendance regularization for #{@regularization.date.strftime('%d %b')}",
        url: admin_attendance_regularizations_path,
        kind: :regularization_request
      )

      redirect_to attendance_regularizations_path,
                  notice: "Attendance regularization updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    req = current_user.attendance_regularizations.find(params[:id])

    unless req.pending?
      redirect_to attendance_regularizations_path,
                  alert: "Only pending regularization requests can be cancelled."
      return
    end

    req.update!(status: :cancelled)

    redirect_to attendance_regularizations_path,
                notice: "Regularization request cancelled."
  end

  private

  def set_regularization
    @regularization =
      current_user.attendance_regularizations.find(params[:id])
  end

  def ensure_pending
    return if @regularization.pending?

    redirect_to attendance_regularizations_path,
                alert: "Only pending regularization requests can be edited."
  end

  def request_params
    params.require(:attendance_regularization).permit(
      :date, :check_in, :check_out, :reason
    )
  end
end
