class UserSubscription
  attr_accessor :user, :product_plan, :product, :options

  def initialize(user:, product_plan:, product:, options:)
    self.user         = user
    self.product_plan = product_plan
    self.product      = product
    self.options      = options

    self.user         = User.new(options) if !self.user
  end

  def register
    self.user = User.new(options)
    user.subscription.expires_at = set_expiry
    user.save
  end

  private

  def create_user
    @user = User.new(options)
  end

  def set_expiry
    DateTime.now + product_plan.interval_count.days
  end

  def subscription_statuses
    Subscription.statuses
  end
end