class CreateShoppeStores < ActiveRecord::Migration
  def change
    create_table :shoppe_stores do |t|
      t.integer :store_no
      t.string :name
      t.string :city
      t.string :phone_number
      t.float :lat
      t.float :lng
      t.timestamps null: false
    end
  end
end
