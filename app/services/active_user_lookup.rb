class ActiveUserLookup < RubyLLM::Tool
  description "Look up gym users based on status filters. Can query active/inactive users and at-risk members (subscription expires within 7 days). Returns user details with subscription information."

  def name
    "active_user_lookup"
  end

  params do
    string :status, description: "Filter users by status: 'active' for active users, 'inactive' for inactive users"
    string :at_risk, description: "Filter users at risk of expiration: 'true' for users whose subscription expires within 7 days, 'false' for not at risk"
  end

  def execute(status: nil, at_risk: nil)
    # Start with all users, eager load subscription and related data
    users = User.members.includes(subscription: { product_plan: :product })

    # Apply status filter (enum)
    users = users.active if status == "active"
    users = users.inactive if status == "inactive"

    # Convert to array for Ruby filtering (at_risk? is an instance method)
    user_records = users.to_a

    # Apply at_risk filter
    if at_risk == "true"
      user_records = user_records.select(&:at_risk?)
    elsif at_risk == "false"
      user_records = user_records.reject(&:at_risk?)
    end

    {
      success: true,
      filters: {
        status: status,
        at_risk: at_risk
      },
      count: user_records.count,
      users: user_records.map do |user|
        {
          id: user.id,
          customer_number: user.customer_number,
          name: user.fullname,
          email: user.email,
          role: user.role,
          status: user.status,
          at_risk: user.at_risk?,
          subscription: {
            status: user.subscription_status_badge,
            expires_at: user.subscription&.expires_at&.iso8601,
            expires_at_formatted: user.subscription&.expires_at&.strftime("%B %d, %Y at %I:%M %p"),
            days_until_expiration: calculate_days_until_expiration(user),
            product_name: user.subscription&.product_plan&.product&.name,
            plan_interval: user.subscription&.product_plan&.interval,
            plan_price: user.subscription&.product_plan&.price
          }
        }
      end
    }

  rescue => e
    {
      success: false,
      error: "An error occurred: #{e.message}"
    }
  end

  private

  def calculate_days_until_expiration(user)
    return nil unless user.subscription&.expires_at

    days = (user.subscription.expires_at.to_date - Date.today).to_i
    days >= 0 ? days : 0  # Don't return negative values for expired
  end
end
