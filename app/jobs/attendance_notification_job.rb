class AttendanceNotificationJob < ApplicationJob
  queue_as :default

  def perform(attendance_id)
    attendance = Attendance.includes(:user).find(attendance_id)
    user = attendance.user

    # Get all admin users
    admins = User.where(role: User::ROLE_ADMIN)

    return if admins.empty?

    # Create notification message
    message = build_notification_message(user, attendance)

    # Create notification records and broadcast to each admin
    admins.each do |admin|
      notification = create_notification_for_admin(admin, attendance, message)
      broadcast_notification_to_admin(admin, notification)
    end

    Rails.logger.info "Sent attendance notification to #{admins.count} admins for user #{user.customer_number}"
  end

  private

  def build_notification_message(user, attendance)
    subscription_status = user.subscription_status_badge
    check_in_time = attendance.created_at.strftime("%I:%M %p")

    "#{user.fullname} (#{user.customer_number}) checked in at #{check_in_time}. Status: #{subscription_status}"
  end

  def create_notification_for_admin(admin, attendance, message)
    Notification.create!(
      recipient: admin,
      notifiable: attendance,
      notification_type: Notification::TYPE_ATTENDANCE_CHECKIN,
      message: message,
      metadata: {
        user_id: attendance.user_id,
        customer_number: attendance.user.customer_number,
        member_name: attendance.user.fullname,
        check_in_time: attendance.created_at.iso8601,
        subscription_status: attendance.user.subscription_status_badge
      }
    )
  end

  def broadcast_notification_to_admin(admin, notification)
    # Broadcast rendered HTML partial to the admin's notification channel
    NotificationChannel.broadcast_to(
      admin,
      {
        type: "notification",
        html: render_notification_partial(notification),
        count: admin.unread_notifications_count
      }
    )
  end

  def render_notification_partial(notification)
    ApplicationController.render(
      partial: "notifications/notification_item",
      locals: { notification: notification }
    )
  end
end
