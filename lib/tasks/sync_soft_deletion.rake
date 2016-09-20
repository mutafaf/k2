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
end