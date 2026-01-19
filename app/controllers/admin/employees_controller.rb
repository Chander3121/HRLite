module Admin
  class EmployeesController < ApplicationController
    before_action :ensure_admin
    before_action :set_user, only: [:edit, :update]

    def index
      @employees = User.employee.includes(:employee_profile)
    end

    def new
      @user = User.new
      @user.build_employee_profile
    end

    def create
      @user = User.new(
        email: user_params[:email],
        role: :employee
      )

      if @user.save(validate: false)
        @user.create_employee_profile(profile_params)

        # 🔐 Send reset-password email
        @user.send_reset_password_instructions

        redirect_to admin_employees_path,
          notice: "Employee created. Password setup email sent."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @profile = @user.employee_profile
    end

    def update
      @profile = @user.employee_profile

      if @profile.update(profile_params)
        redirect_to admin_employees_path,
          notice: "Employee profile updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def set_user
      @user = User.employee.find(params[:id])
    end

    def profile_params
      params.require(:employee_profile).permit(
        :first_name,
        :last_name,
        :designation,
        :joining_date,
        :salary
      )
    end

    private

    def user_params
      params.require(:user).permit(:email)
    end

    def profile_params
      params.require(:employee_profile)
            .permit(:first_name, :last_name, :designation, :joining_date, :salary)
    end
  end
end
