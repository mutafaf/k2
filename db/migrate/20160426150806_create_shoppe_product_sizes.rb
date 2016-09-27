class CreateShoppeProductSizes < ActiveRecord::Migration
  def change
    create_table :shoppe_product_sizes do |t|
      t.integer :product_id
      t.integer :size_id
      t.integer :product_quantity
      t.timestamps null: false
    end
  end
end
