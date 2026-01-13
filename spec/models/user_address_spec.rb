# == Schema Information
#
# Table name: user_addresses
# Database name: primary
#
#  id         :bigint           not null, primary key
#  barangay   :string
#  city       :string
#  province   :string
#  region     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_addresses_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe UserAddress, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
