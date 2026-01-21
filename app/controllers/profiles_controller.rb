class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_employee

  layout "dashboard"

  def edit
    @profile = current_user.employee_profile
  end

  def update
    @profile = current_user.employee_profile

    if @profile.update!(profile_params)
      redirect_to dashboard_path,
        notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def my_id_card
    @profile = current_user.employee_profile
    @qr_code_svg = EmployeeQrCode.new(@profile).svg
  end

  private

  def profile_params
    params.require(:employee_profile).permit(
      :first_name,
      :last_name,
      :phone,
      :dob,
      :gender,
      :address,
      :profile_picture
    )
  end
end
