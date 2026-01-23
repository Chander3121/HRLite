class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.recent.limit(50)
  end

  def read
    notification = current_user.notifications.find(params[:id])
    notification.update!(read_at: Time.current)

    redirect_to notification.url.presence || notifications_path
  end

  def mark_all_read
    current_user.notifications.unread.update_all(read_at: Time.current)
    redirect_to notifications_path, notice: "All notifications marked as read."
  end
end
