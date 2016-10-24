namespace :add_customer_id_to_order do
  
  desc "add Customer id in Order"
  task add_id: :environment do
      puts "Starting....."
     Shoppe::Order.find_each do |order|
        if order.email_address.present? and order.received_at.present?
          user=User.find_by_email(order.email_address) rescue '^^^'
          if user.present?
            order.update_column(:customer_id, user.customer.id)
            puts "Order #{order.id} updated"
          end
        end
     end
      puts "Success!"
  end
end