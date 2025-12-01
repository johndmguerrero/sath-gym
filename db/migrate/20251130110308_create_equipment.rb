class CreateEquipment < ActiveRecord::Migration[8.0]
  def change
    create_table :equipment do |t|
      t.string :name, null: false
      t.string :brand
      t.text :desciption
      t.integer :weight
      t.integer :height
      t.string :sku
      t.references :equipment_categories, null: false, foreign_key: true
      t.timestamps
    end
  end
end
