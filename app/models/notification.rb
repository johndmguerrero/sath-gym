# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  message           :text             not null
#  metadata          :jsonb
#  notification_type :string           not null
#  read              :boolean          default(FALSE), not null
#  read_at           :datetime
#  notifiable_type   :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notifiable_id     :bigint           not null
#  recipient_id      :bigint           not null
#
# Indexes
#
#  index_notifications_on_notifiable                     (notifiable_type,notifiable_id)
#  index_notifications_on_notification_type              (notification_type)
#  index_notifications_on_read                           (read)
#  index_notifications_on_recipient_id                   (recipient_id)
#  index_notifications_on_recipient_unread_recent        (recipient_id,read,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (recipient_id => users.id)
#
class Notification < ApplicationRecord
  # Constants
  TYPE_ATTENDANCE_CHECKIN = "attendance_checkin"

  # Associations
  belongs_to :recipient, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  # Validations
  validates :notification_type, presence: true
  validates :message, presence: true

  # Scopes
  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :for_recipient, ->(user) { where(recipient_id: user.id) }

  # Instance methods
  def mark_as_read!
    update!(read: true, read_at: Time.current)
  end

  def mark_as_unread!
    update!(read: false, read_at: nil)
  end

  def time_ago
    time_diff = Time.current - created_at

    case time_diff
    when 0..59
      "#{time_diff.to_i}s ago"
    when 60..3599
      "#{(time_diff / 60).to_i}m ago"
    when 3600..86399
      "#{(time_diff / 3600).to_i}h ago"
    else
      "#{(time_diff / 86400).to_i}d ago"
    end
  end
end
