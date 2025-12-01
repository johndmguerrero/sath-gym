class AddEquipmentQuantity < ActiveRecord::Migration[8.0]
  def change
    add_column :equipment, :quantity, :integer
  end
end
