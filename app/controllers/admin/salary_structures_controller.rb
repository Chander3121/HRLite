module Admin
  class SalaryStructuresController < ApplicationController
    before_action :ensure_admin
    before_action :set_user
    before_action :set_structure, only: [:show, :edit, :update]

    def show
    end

    def new
      @structure = @user.salary_structures.new(
        effective_from: Date.current,
        status: :active
      )
      build_defaults(@structure)
    end

    def create
      @structure = @user.salary_structures.new(structure_params)

      if @structure.save
        redirect_to admin_employee_salary_structure_path(@user),
          notice: "Salary structure created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @structure.update(structure_params)
        redirect_to admin_employee_salary_structure_path(@user),
          notice: "Salary structure updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.employee.find(params[:employee_id])
    end

    def set_structure
      @structure = @user.active_salary_structure || @user.salary_structures.order(effective_from: :desc).first
    end

    def structure_params
      params.require(:salary_structure).permit(
        :status, :effective_from, :notes,
        salary_components_attributes: [:id, :name, :component_type, :calculation_mode, :amount, :percent_of, :_destroy]
      )
    end

    def build_defaults(structure)
      return if structure.salary_components.any?

      structure.salary_components.build(name: "Basic", component_type: :earning, calculation_mode: :fixed, amount: 0)
      structure.salary_components.build(name: "HRA", component_type: :earning, calculation_mode: :fixed, amount: 0)
      structure.salary_components.build(name: "Special Allowance", component_type: :earning, calculation_mode: :fixed, amount: 0)
      structure.salary_components.build(name: "PF", component_type: :deduction, calculation_mode: :fixed, amount: 0)
    end
  end
end
