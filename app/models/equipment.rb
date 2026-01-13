# == Schema Information
#
# Table name: equipment
# Database name: primary
#
#  id                      :bigint           not null, primary key
#  brand                   :string
#  description             :text
#  height                  :integer
#  name                    :string           not null
#  quantity                :integer
#  sku                     :string
#  weight                  :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  equipment_categories_id :bigint           not null
#
# Indexes
#
#  index_equipment_on_equipment_categories_id  (equipment_categories_id)
#
# Foreign Keys
#
#  fk_rails_...  (equipment_categories_id => equipment_categories.id)
#
class Equipment < ApplicationRecord
  belongs_to :equipment_categories, foreign_key: :equipment_categories_id, class_name: "EquipmentCategory"

  def self.ransackable_attributes(auth_object = nil)
    ["brand", "created_at", "description", "equipment_categories_id", "height", "id", "name", "quantity", "sku", "updated_at", "weight"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["equipment_category"]
  end
end
