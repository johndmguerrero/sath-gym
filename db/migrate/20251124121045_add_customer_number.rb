class AddCustomerNumber < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.string :customer_number
    end
  end
end
