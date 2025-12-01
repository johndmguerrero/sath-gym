class AddUserInformationInUser < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.string :phone_number
      t.string :address
      t.integer :gender, default: 0
    end
  end
end
