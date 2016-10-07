module Shoppe
  class Order < ActiveRecord::Base
    EMAIL_REGEX = /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i
    PHONE_REGEX = /\A[+?\d\ \-x\(\)]{7,}\z/
    ORDER_AMOUNT = 3000
    DELIVERY_CHARGES = 100
      PAYMENT_TYPES = ["Cash On Delivery"]
      # PAYMENT_TYPES = ["Cash On Delivery", "Credit/Debit Card"]

    if Rails.env.production?
      CUSTOMER = "BORJAN PVT LTD"
      PASSWORD = "Bpl2016"
      PATH = "lib/production_payments/"
    else
      CUSTOMER = "Demo Merchant"
      PASSWORD = "Comtrust"
      PATH = "lib/"
    end

    self.table_name = 'shoppe_orders'

    # Orders can have properties
    key_value_store :properties

    # Require dependencies
    require_dependency 'shoppe/order/states'
    require_dependency 'shoppe/order/actions'
    require_dependency 'shoppe/order/billing'
    require_dependency 'shoppe/order/delivery'

    # All items which make up this order
    has_many :order_items, dependent: :destroy, class_name: 'Shoppe::OrderItem', inverse_of: :order
    accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: proc { |a| a['ordered_item_id'].blank? }

    # All products which are part of this order (accessed through the items)
    has_many :products, through: :order_items, class_name: 'Shoppe::Product', source: :ordered_item, source_type: 'Shoppe::Product'

    # The order can belong to a customer
    belongs_to :customer, class_name: 'Shoppe::Customer'
    has_many :addresses, through: :customers, class_name: 'Shoppe::Address'

    # Validations
    validates :token, presence: true
    with_options if: proc { |o| !o.building? } do |order|
      order.validates :email_address, format: { with: EMAIL_REGEX }
      order.validates :phone_number, format: { with: PHONE_REGEX }
    end

    # Set some defaults
    before_validation { self.token = SecureRandom.uuid  if token.blank? }

    # Some methods for setting the billing & delivery addresses
    attr_accessor :save_addresses, :billing_address_id, :delivery_address_id

    # The order number
    #
    # @return [String] - the order number padded with at least 5 zeros
    def number
      id ? id.to_s.rjust(6, '0') : nil
    end

    # The length of time the customer spent building the order before submitting it to us.
    # The time from first item in basket to received.
    #
    # @return [Float] - the length of time
    def build_time
      return nil if received_at.blank?
      created_at - received_at
    end

    # The name of the customer in the format of "Company (First Last)" or if they don't have
    # company specified, just "First Last".
    #
    # @return [String]
    def customer_name
      company.blank? ? full_name : "#{company} (#{full_name})"
    end

    # The full name of the customer created by concatinting the first & last name
    #
    # @return [String]
    def full_name
      "#{first_name} #{last_name}"
    end

    # Is this order empty? (i.e. doesn't have any items associated with it)
    #
    # @return [Boolean]
    def empty?
      order_items.empty?
    end

    # Does this order have items?
    #
    # @return [Boolean]
    def has_items?
      total_items > 0
    end

    # Return the number of items in the order?
    #
    # @return [Integer]
    def total_items
      order_items.inject(0) { |t, i| t + i.quantity }
    end

    def item_per_product

    end

    # Total without any tax and shipping changes
    def products_total
      sub_total = 0
      order_items.each do |item|
        sub_total = sub_total + item.sub_total
      end
      sub_total
    end

    def self.to_xls(options = {}, from, to)
      book = Spreadsheet::Workbook.new :title => "Orders"
      sheet1 = book.create_worksheet :name => "Orders"
      sheet1.column(0).width = 10
      sheet1.column(1).width = 12
      sheet1.column(2).width = 20
      sheet1.column(3).width = 20
      sheet1.column(4).width = 20
      sheet1.column(5).width = 20
      sheet1.column(6).width = 10
      sheet1.column(7).width = 15
      sheet1.column(8).width = 15
      sheet1.column(9).width = 25
      sheet1.column(10).width = 15
      sheet1.column(11).width = 25
      sheet1.column(12).width = 5
      sheet1.column(13).width = 10
      sheet1.column(14).width = 12
      title_format = Spreadsheet::Format.new :color => :green, :weight => :bold, :size => 14, :align => :center
      header_format = Spreadsheet::Format.new :color => :green, :weight => :bold
      date_range_format = Spreadsheet::Format.new :color => :green, :weight => :bold
      i = 0
      sheet1.row(i).default_format = title_format
      sheet1.row(i).push 'Order Summary Status Report'
      sheet1.merge_cells(i, 0, i, 14)
      sheet1.row(i).height = 20
      i = i+1
      sheet1.row(i).default_format = date_range_format
      sheet1.row(i).height = 20

      sheet1.rows[i][1] = "Date From " if from.present?
      sheet1.rows[i][2] =  from.strftime("%b %d, %Y") if from.present?

      sheet1.rows[i][4] = "Date To " if from.present?
      sheet1.rows[i][5] = to.strftime("%b %d, %Y") if to.present?

      i = i+1
      sheet1.row(i).default_format = header_format
      sheet1.row(i).push 'Order#','Order Date', 'Customer Name', 'Category','Article #' ,'Color', 'Size', 'PKR Rupee', 'Contact No' ,'Address', ' City','Email', 'Qty', 'Status', 'Shipped Date'
      mydate=nil
      mytotal=0
      all.each_with_index do |order,p|          
        
        sheet1.row(i).height = 30
        order_id = order.number
        order_date = order.received_at.strftime("%b %d, %Y") if order.received_at.present?
        customer_name = order.customer_name
        contact_no = order.phone_number
        address = order.delivery_address1
        city = order.delivery_city
        order_qty = order.total_items
        order_amount = "#{order.total}"
        status = order.status
        email=order.email_address
        ship_date = order.shipped_at.strftime("%b %d, %Y") if order.shipped_at.present?
        articles = order.order_items.collect(&:product_name).join('') rescue ''
        articles_color = order.order_items.collect(&:variant_name).join('') rescue ''
        sizes = order.order_items.collect(&:items_sizes).join('') rescue ''
        category = order.order_items.collect(&:show_category).join('') rescue ''
        temp=0
        #storing date in mydate it will work in ist iter only
        if p==0
          mydate=order.received_at.strftime("%b %d, %Y") 
        end
        
        
        #start block for the orders of the same date
        if mydate==order.received_at.strftime("%b %d, %Y") 
          #adding amount in total for calculating sum of price of orders having same date
          mytotal=mytotal+order.total
          #start block if the order contain multiple items 
          if order.order_items.count>1
            order.order_items.each_with_index do |order_item,d|
              i+=1
              sheet1.row(i).height = 23
              #if we have ist item in order the insert it full else insert on repeated data
              if d==0
                sheet1.row(i).push order_id, order_date, customer_name, order_item.try(:show_category) ,order_item.try(:product_name) , order_item.try(:variant_name), order_item.try(:items_sizes),  order_amount, contact_no, address, city,  email, order_item.quantity, status, ship_date 
              else
                # byebug
                sheet1.row(i).push "", "", "", order_item.try(:show_category) ,order_item.try(:product_name) , order_item.try(:variant_name), order_item.try(:items_sizes),  "", "", "", "",  "", order_item.quantity, "", ""
                temp=d
              end
            end
            #as we have entered the whole order so now we will merge rows
            order.perform_merging(sheet1,i,temp)
            #else block if the order has only one item in it.
          else
            i+=1
            sheet1.row(i).push order_id, order_date, customer_name , category, articles , articles_color, sizes,  order_amount, contact_no, address, city,  email, order_qty, status, ship_date
          end
        #start for the orders having different dates
        else
          #inserting a row for total 
          i+=1
          sheet1.row(i).height = 25
          sheet1.row(i).default_format = header_format
          mydate=order.received_at.strftime("%b %d, %Y") 
          sheet1.row(i).push "","","","","","","Total",mytotal
          #inserting a row for total end 

          #after inserting the total row we will insert the current order 
          i=i+1
          sheet1.row(i).height = 25
          #if the order contains the multiple items 
          if order.order_items.count>1
            order.order_items.each_with_index do |order_item,d|
              i+=1
              sheet1.row(i).height = 23
              #if we have ist item in order the insert it full else insert on repeated data
              if d==0
                sheet1.row(i).push order_id, order_date, customer_name, order_item.try(:show_category) ,order_item.try(:product_name) , order_item.try(:variant_name), order_item.try(:items_sizes),  order_amount, contact_no, address, city,  email, order_item.quantity, status, ship_date 
              else
                sheet1.row(i).push "", "", "", order_item.try(:show_category) ,order_item.try(:product_name) , order_item.try(:variant_name), order_item.try(:items_sizes),  "", "", "", "",  "", order_item.quantity, "", ""
                temp=d
              end
            end
            order.perform_merging(sheet1,i,temp)
          #if order contains only a single item
          else
            i+=1
            sheet1.row(i).push order_id, order_date, customer_name , category, articles , articles_color, sizes,  order_amount, contact_no, address, city,  email, order_qty, status, ship_date
          end
          #resetting total to zero and adding the amount of current order.
          mytotal=0
           mytotal=mytotal+order.total 
        end        
      end
      return book
    end

    def perform_merging(sheet1,i,temp)
      #arguments details start row ,start col ,end row ,end col
      sheet1.merge_cells(i-temp, 0, i, 0)
      sheet1.merge_cells(i-temp, 1, i, 1)
      sheet1.merge_cells(i-temp, 2, i, 2)
      sheet1.merge_cells(i-temp, 7, i, 7)
      sheet1.merge_cells(i-temp, 8, i, 8)
      sheet1.merge_cells(i-temp, 9, i, 9)
      sheet1.merge_cells(i-temp, 10, i, 10)
      sheet1.merge_cells(i-temp, 11, i, 11)
      # sheet1.merge_cells(i-temp, 12, i, 12)
      sheet1.merge_cells(i-temp, 13, i, 13)
      sheet1.merge_cells(i-temp, 14, i, 14)

    end


    def self.ransackable_attributes(_auth_object = nil)
      %w(id billing_postcode billing_address1 billing_address2 billing_address3 billing_address4 first_name last_name company email_address phone_number consignment_number status received_at) + _ransackers.keys
    end

    def self.ransackable_associations(_auth_object = nil)
      []
    end
  end
end
