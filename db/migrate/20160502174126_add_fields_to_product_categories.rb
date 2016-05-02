class AddFieldsToProductCategories < ActiveRecord::Migration
  def change
    add_column :shoppe_product_categories, :view_on_homepage, :boolean
    add_column :shoppe_product_categories, :homepage_title, :string
    add_column :shoppe_product_categories, :position, :integer
  end
end
