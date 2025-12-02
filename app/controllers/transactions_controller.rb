class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:checkout]

  def index
    add_breadcrumb "Transactions"

  end

  def edit

  end

  def checkout
    add_breadcrumb "Transactions", :transactions_path
    add_breadcrumb "Checkout"

    @transaction = @user.subscription.transactions.build
  end

  private

  def set_user
    @user = User.find_by customer_number: params[:customer_number]
  end

  def set_transaction

  end
end
