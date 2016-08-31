class AddStatusToProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :status, :string
  end
end
