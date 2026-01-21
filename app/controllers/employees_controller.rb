class EmployeesController < ApplicationController
  skip_before_action :authenticate_user!, only: :verify

  def verify
    @profile = EmployeeProfile.find_by(emp_id: params[:emp_id])

    if @profile.nil? || !@profile.active?
      render plain: "Invalid or inactive employee", status: :not_found
    end
  end
end
