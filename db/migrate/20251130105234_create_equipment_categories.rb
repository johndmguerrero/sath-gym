class CreateEquipmentCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :equipment_categories do |t|
      t.string :name
      t.text :desciption
      t.timestamps
    end
  end
end
