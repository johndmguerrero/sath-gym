# == Schema Information
#
# Table name: products
# Database name: primary
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  status      :integer          default("active"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
