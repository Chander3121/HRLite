class PayslipMailer < ApplicationMailer
  def payslip_generated(payslip_request)
    @user = payslip_request.user
    @month = payslip_request.month

    attachments["payslip-#{@month.strftime('%Y-%m')}.pdf"] =
      payslip_request.file.download

    mail(
      to: @user.email,
      subject: "Your payslip for #{@month.strftime('%B %Y')}"
    )
  end
end
