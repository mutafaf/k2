class AddArticlenoAndBrandsToProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :article_no, :string
    add_column :shoppe_products, :brand, :string
  end
end
