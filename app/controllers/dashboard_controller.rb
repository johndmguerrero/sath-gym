class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    add_breadcrumb "Dashboard"

    # Member statistics
    @active_members = User.members.active
    @draft_members = User.members.inactive
    @total_members = @active_members + @draft_members

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

    # Chart data for monthly sales
    @chart_data = Transaction.monthly_sales_data(months: 7)

    # Pie chart data for product plan popularity
    plan_counts = Subscription.joins(product_plan: :product)
                              .group("products.name", "product_plans.interval")
                              .count

    @pie_data = {
      labels: plan_counts.keys.map { |product_name, interval| "#{product_name} - #{interval}" },
      datasets: [{
        label: "Subscriptions by Plan",
        backgroundColor: ["#93c5fd", "#fda4af", "#6ee7b7", "#c4b5fd", "#fbbf24", "#fb923c", "#a78bfa", "#34d399"],
        data: plan_counts.values
      }]
    }
  end
end
