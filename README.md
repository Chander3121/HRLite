# HRLite 🧑‍💼📊

HRLite is a **lightweight HRM (Human Resource Management) system** built with **Ruby on Rails**, designed specifically for **small teams and startups (5–20 employees)**.

It covers the **complete employee lifecycle**:
attendance, leaves, payroll, payslips, and approvals — without the complexity of enterprise HR software.

---

## 🚀 Why HRLite?

Most HR tools are:
- ❌ Overpriced
- ❌ Overcomplicated
- ❌ Built for large enterprises

**HRLite is different**:
- ✅ Simple
- ✅ Opinionated
- ✅ Payroll-accurate
- ✅ Built for small teams

---

## 🧩 Core Features

### 👥 User & Roles
- Admin
- Employee
- Secure authentication using **Devise**
- Role-based dashboards and access

---

### ⏱️ Attendance Management
- Daily **check-in / check-out**
- Auto calculation of worked hours
- Attendance statuses:
  - Present
  - Short Working
  - Half Day
  - Absent
  - Holiday
  - Weekly Off (Saturday / Sunday)

#### Employee Attendance Views
- **Today’s attendance**
  - Check-in time
  - Check-out time
  - Worked hours
  - Attendance status
- **Monthly attendance tracker**
  - Date & day
  - Check-in / check-out time
  - Worked hours
  - Status
- **Monthly summary**
  - Total working days
  - Present
  - Short working
  - Half days
  - Absent
  - Holidays
  - Weekends

---

### 🛠️ Attendance Regularization
- Employees can request corrections for:
  - Missed check-in / check-out
  - Incorrect timings
- Admin approval workflow
- Policies enforced:
  - Requests allowed only within last **X days**
- Automatic attendance recalculation after approval
- Email notifications:
  - Admin notified on request
  - Employee notified on approval/rejection

---

### 🗓️ Holidays & Weekly Offs
- Admin-managed holiday calendar
- Automatic holiday detection
- Weekly offs (Saturday / Sunday)
- Holiday & weekend aware attendance and payroll

---

### 🌴 Leave Management
- Leave types:
  - Paid
  - Sick
  - Casual
- Leave application by employee
- Admin approval / rejection
- Leave balance tracking
- Email notifications on leave decisions

---

### 💰 Payroll System
- Monthly payroll generation
- Salary defined and managed by admin
- Payroll calculated from attendance:
  - Full day = 1
  - Half day = 0.5
  - Absent = unpaid
  - Holidays & weekends = paid
- Prevents payroll generation if salary is missing
- Fully attendance-driven and deterministic

---

### 📄 Payslips (PDF)
- Employee requests payslip by month
- Duplicate requests prevented
- Admin approval & generation
- Professional **PDF payslips** using **Prawn**
- UTF-8 support (₹, names, etc.)
- Secure downloads via **Active Storage**
- Automatic email sent when payslip is generated

---

### ✉️ Email Notifications
- Attendance regularization requests
- Approval / rejection notifications
- Payslip generated notifications
- Configurable for development & production

---

## 🧠 Architecture Highlights

- Service objects for business logic (Payroll, Payslips)
- Strict validations at:
  - Database level
  - Model level
  - Controller level
- Payroll-safe design
- Audit-friendly workflows
- Clean separation of concerns

---

## 🛠️ Tech Stack

- Ruby 4.x
- Rails 8.x
- PostgreSQL
- Tailwind CSS
- esbuild
- Devise (authentication)
- Active Storage
- Prawn (PDF generation)

---

## ⚙️ Setup Instructions

### 1️⃣ Clone the repository
```bash
git clone https://github.com/your-username/hrlite.git
cd hrlite
```

2️⃣ Install dependencies
```
bundle install
```

3️⃣ Setup database
```
bin/rails db:create
bin/rails db:migrate db:seed
```

4️⃣ Install Active Storage
```
bin/rails active_storage:install
bin/rails db:migrate
```

5️⃣ Run the app
```
bin/dev
```

🔐 Default Roles

- Admin

  - Manage employees

  - Manage attendance

  - Approve regularisations

  - Generate payroll

  - Generate payslips

- Employee

  - Track attendance

  - Apply leaves

  - Request attendance regularisation

  - Request and download payslips

📈 Future Enhancements

  - Payroll freeze & lock

  - Tax / PF / ESI deductions

  - Payslip archive

  - Attendance PDF export

  - Audit logs

  - Multi-company support

🤝 Contribution

This project is currently opinionated and self-maintained, but suggestions and improvements are welcome.

📄 License

MIT License
