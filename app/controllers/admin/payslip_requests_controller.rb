module Admin
  class PayslipRequestsController < ApplicationController
    before_action :ensure_admin

    after_action -> { mark_seen("payslip_requests") }, only: :index

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

      if request.update(status: :generated)
        notify_user!(
          user: request.user,
          title: "Payslip Generated",
          message: "Your payslip for #{request.month.strftime('%B %Y')} is now available.",
          url: payslip_requests_path,
          kind: :payslip_request,
          icon: "document-text"
        )
      end

      PayslipMailer
        .payslip_generated(request)
        .deliver_later

      redirect_to admin_payslip_requests_path,
        notice: "Payslip generated and email sent."
    end
  end
end
