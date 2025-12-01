class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.string :remarks
      t.monetize :paying_amount
      t.monetize :subtotal
      t.monetize :total
      t.integer :payment_method, default: 0, null: false
      t.string :reference_number
      t.references :subscription, null: true
      t.timestamps
    end
  end
end
