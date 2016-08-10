namespace :copy_parent_prices_to_variants do
  
  desc "Copy price and old price of parent Product to its variants"
  task update_prices: :environment do
      puts "Starting....."
    Shoppe::Product.find_each do |product|
      if product.has_variants?
        product.variants.each do |variant|
          variant.update_column(:price, product.price)
          puts "Variant ID #{variant.id} updated."
        end

        product.update_column(:old_price, 0)
        puts "Product ID #{product.id} updated."
      end
    end
      puts "**********************Success!*************************"
  end
end