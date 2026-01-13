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
require 'rails_helper'

RSpec.describe Equipment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
