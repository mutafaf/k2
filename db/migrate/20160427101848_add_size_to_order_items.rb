class AddSizeToOrderItems < ActiveRecord::Migration
  def change
    add_column :shoppe_order_items, :size, :string
  end
end
