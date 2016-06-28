class AddDeliveryChargesToOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :delivery_charges, :integer, default: 0
  end
end
