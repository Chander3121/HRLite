require "rqrcode"

class EmployeeQrCode
  def initialize(employee_profile)
    @profile = employee_profile
  end

  def svg
    qr = RQRCode::QRCode.new(verification_url)

    qr.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true
    )
  end

  private

  def verification_url
    Rails.application.routes.url_helpers.verify_employee_url(
      @profile.emp_id
    )
  end
end
