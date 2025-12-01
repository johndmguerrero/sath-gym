# == Schema Information
#
# Table name: subscriptions
#
#  id              :bigint           not null, primary key
#  expires_at      :datetime         not null
#  status          :integer          default("active"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  product_plan_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_subscriptions_on_product_plan_id  (product_plan_id)
#  index_subscriptions_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_plan_id => product_plans.id)
#  fk_rails_...  (user_id => users.id)
#
class Subscription < ApplicationRecord
  enum :status, { active: 0, inactive: 1 }

  belongs_to :user
  belongs_to :product_plan

  has_many :transactions
end
