namespace :update_product_categories_position do
  
  desc "Update Product Categories default position"
  task update_position: :environment do
      puts "Starting....."
    Shoppe::ProductCategory.find_each do |product_category|
      if product_category.position.blank?
        product_category.update_column(:position, 999)
        puts "Product Category: #{product_category.name} Updated."
      end
    end
      puts "Success!"
  end
end