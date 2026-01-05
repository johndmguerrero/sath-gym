class GymStatsLookup < RubyLLM::Tool
  description "Fetches gym statistics like total members, recent attendance, and active subscriptions"

  def execute
    {
      total_members: User.count,
      active_subscriptions: Subscription.active.count,
      recent_attendance_24h: Attendance.logged_last_24_hours.count,
      total_attendance_this_month: Attendance.where(
        created_at: Time.current.beginning_of_month..Time.current
      ).count,
      available_products: Product.count,
      most_popular_plan: most_popular_plan_info
    }
  end

  private

  def most_popular_plan_info
    popular = Subscription.active
      .group(:product_plan_id)
      .count
      .max_by { |_, count| count }

    return nil unless popular

    plan = ProductPlan.includes(:product).find(popular[0])
    {
      name: plan.product.name,
      price: plan.price,
      subscriber_count: popular[1]
    }
  end
end
