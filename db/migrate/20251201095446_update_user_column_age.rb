class UpdateUserColumnAge < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :age, :integer
    add_column :users, :date_of_birth, :datetime
  end
end
