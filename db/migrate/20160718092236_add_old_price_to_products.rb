class AddOldPriceToProducts < ActiveRecord::Migration
  def change

  	add_column :shoppe_products ,:old_price ,:integer
  end
end
