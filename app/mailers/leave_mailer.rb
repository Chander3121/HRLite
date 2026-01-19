class LeaveMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.leave_mailer.status_update.subject
  #
  def status_update(leave)
    @leave = leave
    @user  = leave.user

    mail(
      to: @user.email,
      subject: "Your leave request has been #{@leave.status}"
    )
  end
end
