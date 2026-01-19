class EmployeeMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.employee_mailer.credentials.subject
  #
  def credentials(user, password)
    @user = user
    @password = password
    mail(
      to: @user.email,
      subject: "Your HRLite login credentials"
    )
  end
end
