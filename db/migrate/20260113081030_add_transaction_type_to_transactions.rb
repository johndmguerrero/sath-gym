class AddTransactionTypeToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :transaction_type, :integer, default: 0, null: false
  end
end
