# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


admin = User.find_or_initialize_by(email: "admin@hrlite.com")
admin.role = :admin

# Devise password (only set once)
if admin.new_record?
  admin.password = "password"
  admin.password_confirmation = "password"
end

admin.save!
puts "✅ Admin created: admin@hrlite.com / password"

LetterTemplate.find_or_create_by!(name: "Offer Letter") do |t|
  t.letter_type = :offer_letter
  t.body = <<~TEXT
    Dear {{employee_name}},

    Congratulations!

    We are pleased to offer you the position of {{designation}} at HRLite.

    Employee ID: {{emp_id}}
    Joining Date: {{joining_date}}

    Welcome to the team.

    Regards,
    HRLite HR Team
  TEXT
end

LetterTemplate.find_or_create_by!(name: "Experience Letter") do |t|
  t.letter_type = :experience_letter
  t.body = <<~TEXT
    To Whom It May Concern,

    This is to certify that {{employee_name}}, holding Employee ID {{emp_id}}, was employed with us as a {{designation}} from {{joining_date}}.

    During their tenure, they demonstrated professionalism and dedication.

    We wish them all the best in their future endeavors.

    Regards,
    HRLite HR Team
  TEXT
end

LetterTemplate.find_or_create_by!(name: "Relieving Letter") do |t|
  t.letter_type = :relieving_letter
  t.body = <<~TEXT
    To Whom It May Concern,

    This is to confirm that {{employee_name}}, Employee ID {{emp_id}}, has been relieved from their duties as a {{designation}} effective immediately.

    We thank them for their contributions and wish them success in their future endeavors.

    Regards,
    HRLite HR Team
  TEXT
end
LetterTemplate.find_or_create_by!(name: "Salary Certificate") do |t|
  t.letter_type = :salary_certificate
  t.body = <<~TEXT
    To Whom It May Concern,

    This is to certify that {{employee_name}}, Employee ID {{emp_id}}, is employed with us as a {{designation}}.

    Their current salary details are as follows:
    [Insert Salary Details Here]

    This certificate is being issued upon their request for whatever purpose it may serve.

    Regards,
    HRLite HR Team
  TEXT
end

LetterTemplate.find_or_create_by!(name: "Appreciation Letter") do |t|
  t.letter_type = :appreciation_letter
  t.body = <<~TEXT
    Dear {{employee_name}},

    We would like to express our sincere appreciation for your outstanding performance and dedication as a {{designation}}.

    Your contributions have significantly impacted our team's success.

    Keep up the excellent work!

    Regards,
    HRLite HR Team
  TEXT
end

LetterTemplate.find_or_create_by!(name: "Warning Letter") do |t|
  t.letter_type = :warning_letter
  t.body = <<~TEXT
    Dear {{employee_name}},

    This letter serves as a formal warning regarding your recent conduct/performance as a {{designation}}.

    We expect all employees to adhere to company policies and maintain professional standards.

    Please consider this letter a serious reminder to improve your behavior/performance.

    Regards,
    HRLite HR Team
  TEXT
end

LetterTemplate.find_or_create_by!(name: "Termination Letter") do |t|
  t.letter_type = :termination_letter
  t.body = <<~TEXT
    Dear {{employee_name}},

    We regret to inform you that your employment with HRLite as a {{designation}} is being terminated effective immediately.

    This decision has been made after careful consideration due to [insert reason here].

    Please return any company property in your possession.

    We wish you the best in your future endeavors.

    Regards,
    HRLite HR Team
  TEXT
end

LetterTemplate.find_or_create_by!(name: "Promotion Letter") do |t|
  t.letter_type = :promotion_letter
  t.body = <<~TEXT
    Dear {{employee_name}},

    Congratulations!

    We are pleased to inform you of your promotion to the position of [New Designation] at HRLite.

    Your dedication and hard work as a {{designation}} have been exemplary.

    We look forward to your continued contributions in your new role.

    Regards,
    HRLite HR Team
  TEXT
end

LetterTemplate.find_or_create_by!(name: "Increment Letter") do |t|
  t.letter_type = :increment_letter
  t.body = <<~TEXT
    Dear {{employee_name}},

    We are pleased to inform you that your salary has been increased effective from [Effective Date].

    This increment reflects your valuable contributions as a {{designation}}.

    We appreciate your hard work and dedication to HRLite.

    Regards,
    HRLite HR Team
  TEXT
end

LetterTemplate.find_or_create_by!(name: "Award Certificate") do |t|
  t.letter_type = :award_certificate
  t.body = <<~TEXT
    This is to certify that {{employee_name}}, Employee ID {{emp_id}}, has been awarded the [Award Name] for their exceptional performance and dedication as a {{designation}}.

    Their contributions have greatly benefited our organization.

    We congratulate them on this achievement.

    Regards,
    HRLite HR Team
  TEXT
end

puts "Seeded default admin user and letter templates."
