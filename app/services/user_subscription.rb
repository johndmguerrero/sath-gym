class UserSubscription
  attr_accessor :user, :product_plan, :product, :options

  def initialize(user:, product_plan:, product:, options:)
    self.user         = user
    self.product_plan = product_plan
    self.product      = product
    self.options      = options
  end

  def register
    subscription = user.build_subscription(
      product_plan: product_plan,
      user: user,
      expires_at: set_expiry
    )

    subscription.save
    subscription
  end

  private

  def set_expiry
    DateTime.now + product_plan.interval_count.days
  end

  def subscription_statuses
    Subscription.statuses
  end
end