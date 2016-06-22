namespace :update_image_versions do
  
  desc "Update Products images versions"
  task recreate_versions: :environment do
      puts "Starting....."
    Shoppe::Product.find_each do |product|
      product.default_image.file.recreate_versions! if product.default_image.present?
    end
      puts "Success!"
  end
end