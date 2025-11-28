class RemovePriceCentsInProduct < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :price_cents, :integer
    remove_column :products, :price_currency, :string, default: "PHP"
  end
end
