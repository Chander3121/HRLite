module Admin
  class LettersController < ApplicationController
    before_action :ensure_admin
    before_action :set_letter, only: [:show, :download, :issue]

    def index
      @letters = Letter.includes(:user, :letter_template).order(created_at: :desc)
    end

    def new
      @letter = Letter.new(issued_on: Date.current)
      @employees = User.employee.includes(:employee_profile)
      @templates = LetterTemplate.where(active: true)
    end

    def create
      @letter = Letter.new(letter_params)
      @letter.status = :drafted

      if @letter.save
        redirect_to admin_letter_path(@letter), notice: "Letter drafted."
      else
        @employees = User.employee.includes(:employee_profile)
        @templates = LetterTemplate.where(active: true)
        render :new, status: :unprocessable_entity
      end
    end

    def show; end

    def issue
      pdf_data = Pdfs::LetterPdf.new(@letter).render
      @letter.pdf.attach(
        io: StringIO.new(pdf_data),
        filename: "letter-#{@letter.letter_type}-#{@letter.user.id}.pdf",
        content_type: "application/pdf"
      )

      @letter.update!(status: :issued)

      redirect_to admin_letter_path(@letter), notice: "Letter issued and PDF generated."
    end

    def download
      redirect_to rails_blob_url(@letter.pdf, disposition: "attachment")
    end

    private

    def set_letter
      @letter = Letter.find(params[:id])
    end

    def letter_params
      params.require(:letter).permit(
        :user_id, :letter_template_id, :title, :letter_type, :issued_on, metadata: {}
      )
    end
  end
end
