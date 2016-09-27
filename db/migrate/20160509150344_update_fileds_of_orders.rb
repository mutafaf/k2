class UpdateFiledsOfOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :delivery_city, :string
    rename_column :shoppe_orders, :city, :billing_city
  end
end
