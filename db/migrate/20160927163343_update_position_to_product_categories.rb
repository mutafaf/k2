class UpdatePositionToProductCategories < ActiveRecord::Migration
  def change
  	change_column_default :shoppe_product_categories, :position, 999
  end
end
