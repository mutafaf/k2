class AddStatusToProductCategories < ActiveRecord::Migration
  def change
    add_column :shoppe_product_categories, :status, :string
  end
end
