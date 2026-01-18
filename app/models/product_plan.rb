# == Schema Information
#
# Table name: product_plans
# Database name: primary
#
#  id             :bigint           not null, primary key
#  interval       :integer          default("monthly")
#  interval_count :integer
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("PHP"), not null
#  status         :integer          default("active")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  product_id     :bigint           not null
#
# Indexes
#
#  index_product_plans_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
class ProductPlan < ApplicationRecord
  enum :status, { active: 0, inactive: 1}
  enum :interval, { monthly: 0, yearly: 1, daily: 2}, default: 0
  belongs_to :product

  after_initialize :set_default_interval_count

  monetize :price_cents

  def display_plan
    "#{price.format} -- #{interval}"
  end

  private

  def set_default_interval_count
    self.interval_count ||= 1
  end
end
