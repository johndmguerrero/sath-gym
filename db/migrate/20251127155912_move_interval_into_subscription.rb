class MoveIntervalIntoSubscription < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :interval, :integer
  end
end
