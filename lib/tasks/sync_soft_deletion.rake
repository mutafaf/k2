namespace :sync_soft_deletion do
  
  desc "Sync soft deletion of Product to its variants"
  task update_status: :environment do
      puts "Starting....."
    Shoppe::Product.unscoped.find_each do |product|
      if product.variants.present? and product.status == "deleted"
        product.variants.each do |variant|
          variant.update_column(:status, product.status)
          puts "Variant ID #{variant.id} updated."
        end
      end
    end
      puts "**********************Done!*************************"
  end

  task update_permalink: :environment do
      puts "Update Permalink of Soft Deleted Products....."
    Shoppe::Product.unscoped.where(status: "deleted").each do |product|
      product.permalink = [product.permalink,"-",SecureRandom.hex(8)].join
      product.save
      puts "Product Name: #{product.name} updated."
    end
      puts "**********************Done!*************************"
  end
end