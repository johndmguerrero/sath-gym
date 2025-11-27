# == Schema Information
#
# Table name: products
#
#  id             :bigint           not null, primary key
#  description    :text
#  interval       :integer          default(0), not null
#  name           :string
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("PHP"), not null
#  status         :integer          default("active"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Product < ApplicationRecord
  enum :status, { active: 0, inactive: 1}

  monetize :price_cents
end
