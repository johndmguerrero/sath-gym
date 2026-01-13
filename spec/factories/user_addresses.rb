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
FactoryBot.define do
  factory :user_address do
    
  end
end
