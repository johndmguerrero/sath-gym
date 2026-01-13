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
class Product < ApplicationRecord
  enum :status, { active: 0, inactive: 1}
  has_many :product_plans
  alias_method :plans, :product_plans

  accepts_nested_attributes_for :product_plans, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validate :must_have_at_least_one_plan

  private

  def must_have_at_least_one_plan
    # Check for plans that are not marked for destruction
    active_plans = product_plans.reject { |plan| plan.marked_for_destruction? }
    if active_plans.empty?
      errors.add(:base, "Product must have at least one plan")
    end
  end
end
