# == Schema Information
#
# Table name: equipment_categories
#
#  id         :bigint           not null, primary key
#  desciption :text
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class EquipmentCategory < ApplicationRecord
  has_many :equipment, foreign_key: :equipment_categories_id

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "desciption", "id", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["equipment"]
  end
end
