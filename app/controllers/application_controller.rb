class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  layout :set_layout

  before_action :load_admin_sidebar_state, if: -> { current_user&.admin? }

  def after_sign_in_path_for(resource)
    resource.admin? ? admin_dashboard_path : dashboard_path
  end

  def set_layout
    devise_controller? ? "auth" : "application"
  end

  def load_admin_sidebar_state
    # ---- Leave Requests ----
    @leave_count  = LeaveRequest.pending.count
    @leave_latest = LeaveRequest.pending.maximum(:updated_at)
    @leave_pulsing = new_activity?("leave_requests", @leave_latest)

    # ---- Attendance Regularizations ----
    @regularization_count  = AttendanceRegularization.pending.count
    @regularization_latest = AttendanceRegularization.pending.maximum(:updated_at)
    @regularization_pulsing = new_activity?("attendance_regularizations", @regularization_latest)

    # ---- Payslip Requests ----
    @payslip_count  = PayslipRequest.pending.count
    @payslip_latest = PayslipRequest.pending.maximum(:updated_at)
    @payslip_pulsing = new_activity?("payslip_requests", @payslip_latest)
  end

  def notify_user!(user:, title:, message:, url: nil, kind: :general, icon: "bell")
    notification = Notification.create!(
      user: user,
      title: title,
      message: message,
      url: url,
      kind: kind
    )

    Turbo::StreamsChannel.broadcast_prepend_to(
      "user_toasts_#{user.id}",
      target: "toast-container",
      partial: "shared/toast",
      locals: {
        title: title,
        message: message,
        icon: icon,
        url: url,
        notification_id: notification.id
      }
    )
  end

  def notify_admins!(title:, message:, url:, kind: :general)
    User.admin.find_each do |admin|
      Notification.create!(
        user: admin,
        title: title,
        message: message,
        url: url,
        kind: kind
      )
    end

    # realtime toast
    broadcast_admin_toast(title: title, message: message, url: url)
  end

  def broadcast_admin_toast(title:, message:, url:)
    Turbo::StreamsChannel.broadcast_prepend_to(
      "admin_toasts",
      target: "toast-container",
      partial: "shared/toast",
      locals: {
        title: title,
        message: message,
        icon: "bell",
        url: url
      }
    )
  end

  private

  def new_activity?(key, latest_updated_at)
    return false if latest_updated_at.blank?

    pref = current_user.admin_preferences.find_by(key: key)
    pref.nil? || pref.last_seen_at.nil? || pref.last_seen_at < latest_updated_at
  end

  def mark_seen(key)
    AdminPreference.find_or_create_by!(user: current_user, key: key)
                  .update!(last_seen_at: Time.current)
  end

  def ensure_admin
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end

  def ensure_employee
    redirect_to root_path, alert: "Not authorized" unless current_user.employee?
  end
end
