class UpdateProductPlanInterval < ActiveRecord::Migration[8.0]
  def change
    change_column_default :product_plans, :interval, from: nil, to: 0
  end
end
