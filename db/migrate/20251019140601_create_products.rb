class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :status, default: 0, null: false
      t.monetize :price
      t.integer :interval, default: 0, null: false
      t.timestamps
    end
  end
end
