class UpdateEquipmentDescriptionColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :equipment, :desciption, :description
  end
end
