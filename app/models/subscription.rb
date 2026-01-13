# == Schema Information
#
# Table name: subscriptions
# Database name: primary
#
#  id              :bigint           not null, primary key
#  expires_at      :datetime         not null
#  status          :integer          default("inactive"), not null
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
  enum :status, { inactive: 0, active: 1 }

  belongs_to :user
  belongs_to :product_plan

  has_many :transactions

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  def expired?
    return true if expires_at.nil?

    expires_at < Time.now
  end
end
