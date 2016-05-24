class AddColorNameToProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :color_name, :string
  end
end
