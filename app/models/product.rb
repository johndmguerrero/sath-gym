# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  status      :integer          default("active"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Product < ApplicationRecord
  enum :status, { active: 0, inactive: 1}
  has_many :product_plans
  alias_method :plans, :product_plans

  accepts_nested_attributes_for :product_plans

  validates :name, presence: true
  validate :must_have_at_least_one_plan

  private

  def must_have_at_least_one_plan
    if product_plans.empty?
      errors.add(:base, "Product must have at least one plan")
    end
  end
end
