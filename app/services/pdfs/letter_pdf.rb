module Pdfs
  class LetterPdf
    FONT_REGULAR = Rails.root.join(
      "app/assets/fonts/DejaVuSans.ttf"
    )

    FONT_BOLD = Rails.root.join(
      "app/assets/fonts/DejaVuSans-Bold.ttf"
    )

    def initialize(letter)
      @letter = letter
      @user = letter.user
      @profile = @user.employee_profile
      @template = letter.letter_template
    end

    def render
      Prawn::Document.new(page_size: "A4") do |pdf|
      pdf.font_families.update(
        "DejaVuSans" => {
          normal: FONT_REGULAR,
          bold:   FONT_BOLD
        }
      )
      pdf.font("DejaVuSans")

      pdf.text "HRLite", size: 22, style: :bold, align: :center
      pdf.move_down 5
      pdf.text @letter.title, size: 16, style: :bold, align: :center
      pdf.move_down 10

      pdf.text "Date: #{@letter.issued_on.strftime('%d %B %Y')}", size: 10, align: :right
      pdf.move_down 15

      body = render_template(@template.body)

      pdf.text body, size: 12, leading: 4
      pdf.move_down 25

      pdf.text "Regards,", size: 12
      pdf.move_down 8
      pdf.text "HRLite HR Team", style: :bold
      end.render
    end

    private

    def render_template(text)
      text
      .gsub("{{employee_name}}", "#{@profile.first_name} #{@profile.last_name}")
      .gsub("{{emp_id}}", @profile.emp_id.to_s)
      .gsub("{{designation}}", @profile.designation.to_s)
      .gsub("{{joining_date}}", @profile.joining_date&.strftime("%d %b %Y").to_s)
    end
  end
end
