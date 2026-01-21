class AttendanceRegularizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_employee

  def index
    @requests = current_user.attendance_regularizations.order(date: :desc)
  end

  def new
    @request = AttendanceRegularization.new(date: params[:date])
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

  private

  def request_params
    params.require(:attendance_regularization).permit(
      :date, :check_in, :check_out, :reason
    )
  end
end
