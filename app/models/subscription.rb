class Subscription < ApplicationRecord
  belongs_to :user, foreign_key: "user_id"
  belongs_to :product, foreign_key: "product_id"

end
