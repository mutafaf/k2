class AddFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :city, :string
    add_column :shoppe_orders, :order_notes, :text

    change_column :shoppe_orders, :billing_address1,  :text
    change_column :shoppe_orders, :delivery_address1,  :text
  end
end
