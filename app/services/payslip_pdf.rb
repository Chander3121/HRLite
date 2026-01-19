class PayslipPdf
  FONT_REGULAR = Rails.root.join(
    "app/assets/fonts/DejaVuSans.ttf"
  )

  FONT_BOLD = Rails.root.join(
    "app/assets/fonts/DejaVuSans-Bold.ttf"
  )

  def initialize(user, month)
    @user = user
    @month = month
    @payroll = Payroll.find_by!(
      user: user,
      month: month.beginning_of_month
    )
  end

  def render
    Prawn::Document.new do |pdf|
      # ✅ Register font family
      pdf.font_families.update(
        "DejaVuSans" => {
          normal: FONT_REGULAR,
          bold:   FONT_BOLD
        }
      )

      # ✅ Use the family
      pdf.font "DejaVuSans"

      pdf.text "Payslip – #{@month.strftime('%B %Y')}",
        size: 18,
        style: :bold

      pdf.move_down 20

      pdf.text "Employee: #{@user.email}"
      pdf.text "Salary: ₹ #{@payroll.gross_salary}"
      pdf.text "Paid Days: #{@payroll.paid_days}"
      pdf.text "Net Salary: ₹ #{@payroll.net_salary}",
        style: :bold

      pdf.move_down 20
      pdf.text "HRLite", size: 10, align: :right
    end.render
  end
end
