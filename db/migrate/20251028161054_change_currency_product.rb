class ChangeCurrencyProduct < ActiveRecord::Migration[8.0]
  def change
    change_column_default :products, :price_currency, from: "USD", to: "PHP"
  end
end
