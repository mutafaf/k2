class AddPaymentToOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :payment_method, :string
  end
end
