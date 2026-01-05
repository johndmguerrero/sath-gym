class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:mark_as_read]

  # PATCH /notifications/:id/mark_as_read
  def mark_as_read
    @notification.mark_as_read!

    # Broadcast updated count
    broadcast_count_update

    head :ok
  end

  # POST /notifications/mark_all_as_read
  def mark_all_as_read
    current_user.notifications.unread.update_all(
      read: true,
      read_at: Time.current
    )

    # Broadcast updated count
    broadcast_count_update

    # Replace notification list with all marked as read
    render turbo_stream: turbo_stream.replace(
      "notification-list",
      partial: "notifications/notification_list",
      locals: { notifications: current_user.notifications.recent.limit(20) }
    )
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end

  def broadcast_count_update
    NotificationChannel.broadcast_to(
      current_user,
      {
        type: "count_update",
        count: current_user.unread_notifications_count
      }
    )
  end
end
