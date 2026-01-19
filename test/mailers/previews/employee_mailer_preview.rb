# Preview all emails at http://localhost:3000/rails/mailers/employee_mailer
class EmployeeMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/employee_mailer/credentials
  def credentials
    EmployeeMailer.credentials
  end
end
