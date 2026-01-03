class CreateUserAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :user_addresses do |t|
      t.string :barangay
      t.string :city
      t.string :province
      t.string :region
      t.references :user, null: false
      t.timestamps
    end
  end
end
