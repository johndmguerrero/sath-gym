class SubscriptionTransaction
  attr_accessor :subscription, :user, :params

  def initialize(subscription: , user:, params:)
    self.subscription       = subscription
    self.user               = user
    self.params             = params
  end

  def register

  end

  def renewal

  end

  def walkins
    @transaction = Transaction.new(
      paying_amount: params[:payment_amount],
      remarks: params[:remarks],
      payment_method: params[:payment_method],
      reference_number: params[:reference_number]
    )

    if @transaction.save
      @transaction
    end
  end
end