class AddHomeCategoryPositionToProductCategories < ActiveRecord::Migration
  def change
    add_column :shoppe_product_categories, :home_categories_position, :integer
  end
end
