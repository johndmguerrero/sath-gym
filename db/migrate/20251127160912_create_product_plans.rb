class CreateProductPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :product_plans do |t|
      t.references :product, null: false, foreign_key: true
      t.monetize :price
      t.integer :interval
      t.integer :interval_count
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
