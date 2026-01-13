class TransactionsController < ApplicationController
  before_action :authenticate_user!
  include Pagy::Backend
  before_action :set_user, only: [:checkout, :renewal, :show_checkout, :show_renewal]
  before_action :set_transaction, only: [:show_checkout, :show_renewal]

  def index
    add_breadcrumb "Transactions"

    records = Transaction.includes(subscription: :user).order(created_at: :desc)
    @search = records.ransack(params[:q])
    @pagy, @transactions = pagy(@search.result)
  end

  def new
    @transaction = Transaction.new
  end

  def edit
  end

  def checkout
    add_breadcrumb "Transactions", :transactions_path
    add_breadcrumb "Checkout"

    @transaction = @user.subscription.transactions.build
  end

  def renewal
    add_breadcrumb "Transactions", :transactions_path
    add_breadcrumb "Renewal"

    @transaction = @user.subscription.transactions.build
  end

  def show_checkout
    add_breadcrumb "Transactions", :transactions_path
    add_breadcrumb "Checkout Details"
    render :checkout
  end

  def show_renewal
    add_breadcrumb "Transactions", :transactions_path
    add_breadcrumb "Renewal Details"
    render :renewal
  end

  def create
    if params[:customer_number].present?
      # Existing flow for subscribed users (checkout or renewal)
      @user = User.find_by(customer_number: params[:customer_number])
      is_renewal = params[:renewal].present?
      @transaction = @user.subscription.transactions.build(transaction_params)
      @transaction.transaction_type = is_renewal ? :renewal : :checkout

      if @transaction.save
        if is_renewal
          # For renewal, extend the subscription expiration
          extend_subscription_expiration(@user.subscription)
          @user.update(status: :active)
          redirect_to edit_member_path(@user.customer_number)
        else
          # For initial checkout, just activate the member
          @user.update(status: :active)
          @user.subscription.active!
          redirect_to edit_member_path(@user.customer_number)
        end
      else
        render (is_renewal ? :renewal : :checkout), status: :unprocessable_entity
      end
    end
  end

  private

  def set_user
    @user = User.find_by customer_number: params[:customer_number]
  end

  def set_transaction
    @transaction = @user.subscription.transactions.find(params[:id])
  end

  def extend_subscription_expiration(subscription)
    product_plan = subscription.product_plan
    current_expiration = subscription.expires_at

    # Calculate new expiration based on the plan interval
    new_expiration = case product_plan.interval
    when "daily"
      current_expiration + (product_plan.interval_count || 1).days
    when "monthly"
      current_expiration + (product_plan.interval_count || 1).months
    when "yearly"
      current_expiration + (product_plan.interval_count || 1).years
    else
      current_expiration + 1.month # default to monthly
    end

    subscription.update(expires_at: new_expiration, status: :active)
  end

  def transaction_params
    params.require(:transaction).permit(
      :payment_method,
      :reference_number,
      :remarks,
      :subtotal,
      :total,
      :paying_amount
    )
  end
end
