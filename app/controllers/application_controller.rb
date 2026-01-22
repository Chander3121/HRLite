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

  private

  def load_admin_sidebar_state
    @leave_count = LeaveRequest.pending.count
    @leave_latest = LeaveRequest.pending.maximum(:updated_at)

    pref = current_user.admin_preferences.find_by(key: "leave_requests")
    @leave_pulsing = pref.nil? || (@leave_latest && pref.last_seen_at < @leave_latest)
  end

  def ensure_admin
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end

  def ensure_employee
    redirect_to root_path, alert: "Not authorized" unless current_user.employee?
  end
end
