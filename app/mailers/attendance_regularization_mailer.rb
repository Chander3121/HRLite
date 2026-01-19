class AttendanceRegularizationMailer < ApplicationMailer
  def notify_admin(request)
    @request = request

    mail(
      to: User.admin.pluck(:email),
      subject: "Attendance Regularization Request"
    )
  end

  def notify_employee(request)
    @request = request

    mail(
      to: request.user.email,
      subject: "Attendance Regularization #{request.status.titleize}"
    )
  end
end
