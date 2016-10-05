class AddColumnToShopeeProducts < ActiveRecord::Migration
  def change
  	add_column :shoppe_products, :position, :integer ,:default => 999
  end
end
