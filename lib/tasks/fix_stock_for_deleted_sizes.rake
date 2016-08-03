namespace :fix_stock_for_deleted_sizes do
  
  desc "Delete stock for deleted sizes"
  task update_stock: :environment do
      puts "Starting....."
    Shoppe::StockLevelAdjustment.find_each do |sla|
      if sla.size.blank?
        sla.destroy
        puts "StockLevelAdjustment ID #{sla.id} deleted."
      end
    end
      puts "**********************Success!*************************"
  end

  desc "Delete ProductSize(middle table entries) for deleted sizes"
  task fix_product_sizes: :environment do
      puts "Starting....."
    Shoppe::ProductSize.find_each do |product_size|
      if product_size.size.blank?
        product_size.destroy
        puts "ProductSize ID #{product_size.id} deleted."
      end
    end
      puts "**********************Success!*************************"
  end

end