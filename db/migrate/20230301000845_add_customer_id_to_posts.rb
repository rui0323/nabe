class AddCustomerIdToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :customer_id, :integer
  end
end
