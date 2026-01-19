module Admin
  class PayslipRequestsController < ApplicationController
    before_action :ensure_admin

    def index
      @requests = PayslipRequest
                    .includes(:user)
                    .order(month: :desc)
    end

    def update
      request = PayslipRequest.find(params[:id])

      pdf = PayslipPdf.new(request.user, request.month).render

      request.file.attach(
        io: StringIO.new(pdf),
        filename: "payslip-#{request.month.strftime('%Y-%m')}.pdf",
        content_type: "application/pdf"
      )

      request.update!(status: :generated)

      # ✅ SEND EMAIL
      PayslipMailer
        .payslip_generated(request)
        .deliver_later

      redirect_to admin_payslip_requests_path,
        notice: "Payslip generated and email sent."
    end
  end
end
