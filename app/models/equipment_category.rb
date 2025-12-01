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
end
