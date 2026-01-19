# Preview all emails at http://localhost:3000/rails/mailers/leave_mailer
class LeaveMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/leave_mailer/status_update
  def status_update
    LeaveMailer.status_update
  end
end
