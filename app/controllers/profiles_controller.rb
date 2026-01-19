class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_employee

  def edit
    @profile = current_user.employee_profile
  end

  def update
    @profile = current_user.employee_profile

    if @profile.update(profile_params)
      redirect_to dashboard_path,
        notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:employee_profile).permit(
      :first_name,
      :last_name
      # add :phone, :address later if needed
    )
  end
end
