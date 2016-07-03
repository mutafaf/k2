class AddCancelAndRefundFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :canceled_at, :datetime
    add_column :shoppe_orders, :canceled_by, :integer

    add_column :shoppe_orders, :returned_at, :datetime
    add_column :shoppe_orders, :returned_by, :integer
  end
end
