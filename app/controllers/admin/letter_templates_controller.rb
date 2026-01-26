module Admin
  class LetterTemplatesController < ApplicationController
    before_action :ensure_admin
    before_action :set_template, only: [:edit, :update, :destroy]

    def index
      @templates = LetterTemplate.order(created_at: :desc)
    end

    def new
      @template = LetterTemplate.new
    end

    def create
      @template = LetterTemplate.new(template_params)

      if @template.save
        redirect_to admin_letter_templates_path, notice: "Template created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @template.update(template_params)
        redirect_to admin_letter_templates_path, notice: "Template updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @template.destroy
      redirect_to admin_letter_templates_path, notice: "Template deleted."
    end

    private

    def set_template
      @template = LetterTemplate.find(params[:id])
    end

    def template_params
      params.require(:letter_template).permit(:name, :letter_type, :body, :active)
    end
  end
end
