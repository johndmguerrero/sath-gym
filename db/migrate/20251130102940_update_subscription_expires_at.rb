class UpdateSubscriptionExpiresAt < ActiveRecord::Migration[8.0]
  def change
    remove_column :subscriptions, :expires_at, :date, null: false
    add_column :subscriptions, :expires_at, :datetime, null: false
  end
end
