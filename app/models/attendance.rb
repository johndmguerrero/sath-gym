# == Schema Information
#
# Table name: attendances
#
#  id         :bigint           not null, primary key
#  remarks    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_attendances_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Attendance < ApplicationRecord
  belongs_to :user
  has_many :notifications, as: :notifiable, dependent: :destroy

  after_commit :send_notification, on: :create

  delegate :customer_number, to: :user

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  scope :logged_last_24_hours, -> { includes(:user).where("created_at >= ?", 24.hours.ago) }

  def send_notification
    # Enqueue async job to avoid blocking API response
    AttendanceNotificationJob.perform_later(id)
  end
end
