class AddFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :new_arrivals, :boolean
    add_column :shoppe_products, :hot_selling, :boolean
  end
end
