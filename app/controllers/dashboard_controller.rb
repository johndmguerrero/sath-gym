class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    add_breadcrumb "Dashboard"

    # Member statistics
    @active_members = User.members.active
    @draft_members = User.members.inactive
    @total_members = User.members.count

    # Attendance statistics
    @recent_attendances = Attendance.includes(:user)
                                    .logged_last_24_hours
                                    .limit(10)
    @today_attendance_count = Attendance.where("created_at >= ?", Time.current.beginning_of_day).count

    # Expiring memberships (next 30 days)
    @expiring_soon = Subscription.includes(:user, :product_plan)
                                 .active
                                 .where("expires_at <= ?", 30.days.from_now)
                                 .where("expires_at > ?", Time.current)
                                 .order(:expires_at)
                                 .limit(10)

    # Revenue statistics
    @monthly_revenue = Transaction.where("created_at >= ?", Time.current.beginning_of_month)
                                 .sum(:total_cents) / 100.0
    @today_revenue = Transaction.where("created_at >= ?", Time.current.beginning_of_day)
                               .sum(:total_cents) / 100.0
  end
end
