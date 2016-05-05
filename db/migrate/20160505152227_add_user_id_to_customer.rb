class AddUserIdToCustomer < ActiveRecord::Migration
  def change
    add_column :shoppe_customers, :user_id, :integer
  end
end
