namespace :add_images_to_default_variant do
  
  desc "Assign Product Images to Default Variant"
  task update_attachments: :environment do
      puts "Starting....."
    Shoppe::Product.find_each do |product|
      if product.has_variants? and  product.default_variant.present?
        
        product.attachments.each do |attachment|
          attachment.update_column(:parent_id, product.default_variant.id)
        end
        puts "Product ID #{product.id} updated."
      end
    end
      puts "**********************Success!*************************"
  end
end