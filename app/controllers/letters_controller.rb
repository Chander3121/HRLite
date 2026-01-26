class LettersController < ApplicationController
  before_action :ensure_employee

  def index
    @letters = current_user.letters.issued.order(issued_on: :desc)
  end

  def show
    @letter = current_user.letters.find(params[:id])
  end

  def download
    letter = current_user.letters.issued.find(params[:id])
    redirect_to rails_blob_url(letter.pdf, disposition: "attachment")
  end

  private

  def ensure_employee
    redirect_to root_path, alert: "Not authorized" unless current_user.employee?
  end
end
