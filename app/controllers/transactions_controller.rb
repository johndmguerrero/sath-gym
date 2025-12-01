class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    add_breadcrumb "Transactions"

  end

  def edit

  end

  private

  def set_transaction
    # @transaction = Transaction.find_by_id: params[:id]
  end
end
