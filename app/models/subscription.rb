# == Schema Information
#
# Table name: subscriptions
#
#  id         :bigint           not null, primary key
#  expires_at :date
#  status     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_subscriptions_on_product_id  (product_id)
#  index_subscriptions_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (user_id => users.id)
#
class Subscription < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :product, foreign_key: "product_id"
end
