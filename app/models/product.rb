class Product < ApplicationRecord
  enum :status, { active: 0, inactive: 1}

  monetize :price_cents
end
