require 'roo'
require 'globalize'

module Shoppe
  class Product < ActiveRecord::Base
    self.table_name = 'shoppe_products'

    QUANTITY = (1..15).to_a

    PER_PAGE = 12

    NEW_ARRIVALS = "New Arrivals"

    HOT_SELLING = "Hot Selling"

    PRICE_RANGE = "Price"

    # Add dependencies for products
    require_dependency 'shoppe/product/product_attributes'
    require_dependency 'shoppe/product/variants'

    ratyrate_rateable "name"

    has_many :product_sizes, class_name: 'Shoppe::ProductSize'
    has_many :sizes, through: :product_sizes, class_name: 'Shoppe::Size'

    # Attachments for this product
    has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Shoppe::Attachment'

    # The product's categorizations
    #
    # @return [Shoppe::ProductCategorization]
    has_many :product_categorizations, dependent: :destroy, class_name: 'Shoppe::ProductCategorization', inverse_of: :product
    # The product's categories
    #
    # @return [Shoppe::ProductCategory]
    has_many :product_categories, class_name: 'Shoppe::ProductCategory', through: :product_categorizations

    # The product's tax rate
    #
    # @return [Shoppe::TaxRate]
    belongs_to :tax_rate, class_name: 'Shoppe::TaxRate'

    # Ordered items which are associated with this product
    has_many :order_items, dependent: :restrict_with_exception, class_name: 'Shoppe::OrderItem', as: :ordered_item

    # Orders which have ordered this product
    has_many :orders, through: :order_items, class_name: 'Shoppe::Order'

    # Stock level adjustments for this product
    has_many :stock_level_adjustments, dependent: :destroy, class_name: 'Shoppe::StockLevelAdjustment', as: :item

    # Validations
    with_options if: proc { |p| p.parent.nil? } do |product|
      product.validate :has_at_least_one_product_category
      product.validates :description, presence: true
      product.validates :short_description, presence: true
    end
    validates :name, presence: true
    validates :permalink, presence: true, uniqueness: true, permalink: true
    validates :sku, presence: true
    # validates :article_no, :brand, presence: true
    # validates_presence_of :size_ids, :message => "Available Sizes can't be blank" 
    validates :weight, numericality: true
    validates :price, numericality: true
    validates :cost_price, numericality: true, allow_blank: true

    # Before validation, set the permalink if we don't already have one
    before_validation { self.permalink = name.parameterize if permalink.blank? && name.is_a?(String) }

    after_create :create_default_variant
    after_save :update_active_for_variants

    # All active products
    scope :active, -> { where(active: true) }
    scope :color_multi, -> { where(color_name: "Multi") }
    # All featured products
    scope :featured, -> { where(featured: true) }

    # Localisations
    translates :name, :permalink, :description, :short_description
    scope :ordered, -> { includes(:translations).order(:name) }

    def attachments=(attrs)
      if attrs['default_image']['file'].present? then attachments.build(attrs['default_image']) end
      # if attrs['data_sheet']['file'].present? then attachments.build(attrs['data_sheet']) end

      if attrs['extra']['file'].present? then attrs['extra']['file'].each { |attr| attachments.build(file: attr, parent_id: attrs['extra']['parent_id'], parent_type: attrs['extra']['parent_type']) } end
    end

    def update_active_for_variants
      if self.variants.present? and self.active_changed?
        self.variants.each do |variant|
          variant.active = self.active
          variant.save
        end
      end
    end

    def create_default_variant
      variant = self.variants.new
      variant.name = self.color_name
      variant_name = self.name.squish.gsub(" ", "-")
      variant.permalink = "#{variant_name}-default"
      variant.sku = "sku"
      variant.color = self.color
      variant.sizes = self.sizes
      variant.default = true
      variant.save
    end

    # Return the name of the product
    #
    # @return [String]
    def full_name
      parent ? "#{parent.name} (#{name})" : name
    end

    # Is this product orderable?
    #
    # @return [Boolean]
    def orderable?
      return false unless active?
      return false if has_variants?
      true
    end

    # The price for the product
    #
    # @return [BigDecimal]
    # def price
    #   # self.default_variant ? self.default_variant.price : read_attribute(:price)
    #   default_variant ? default_variant.price : read_attribute(:price)
    # end

    # Is this product currently in stock?
    #
    # @return [Boolean]
    def in_stock?
      default_variant ? default_variant.in_stock? : (stock_control? ? stock > 0 : true)
    end

    # Return the total number of items currently in stock
    #
    # @return [Fixnum]
    #Stock is only for variants and default variant Not For main Product itself
    def stock(size_id = nil)
      if size_id.present?
        return stock_level_adjustments.where(size_id: size_id).sum(:adjustment)
      end

      return stock_level_adjustments.sum(:adjustment)
    end

    # Return the first product category
    #
    # @return [Shoppe::ProductCategory]
    def product_category
      product_categories.first
    rescue
      nil
    end

    # Return attachment for the default_image role
    #
    # @return [String]
    def default_image
      attachments.for('default_image')
    end

    # Set attachment for the default_image role
    def default_image_file=(file)
      attachments.build(file: file, role: 'default_image')
    end

    # Return attachment for the data_sheet role
    #
    # @return [String]
    def data_sheet
      attachments.for('data_sheet')
    end

    # Search for products which include the given attributes and return an active record
    # scope of these products. Chainable with other scopes and with_attributes methods.
    # For example:
    #
    #   Shoppe::Product.active.with_attribute('Manufacturer', 'Apple').with_attribute('Model', ['Macbook', 'iPhone'])
    #
    # @return [Enumerable]
    def self.with_attributes(key, values)
      product_ids = Shoppe::ProductAttribute.searchable.where(key: key, value: values).pluck(:product_id).uniq
      where(id: product_ids)
    end

    # Imports products from a spreadsheet file
    # Example:
    #
    #   Shoppe:Product.import("path/to/file.csv")
    def self.import(file)
      spreadsheet = open_spreadsheet(file)
      spreadsheet.default_sheet = spreadsheet.sheets.first
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]

        # Don't import products where the name is blank
        next if row['name'].nil?
        if product = where(name: row['name']).take
          # Dont import products with the same name but update quantities
          qty = row['qty'].to_i
          if qty > 0
            product.stock_level_adjustments.create!(description: I18n.t('shoppe.import'), adjustment: qty)
          end
        else
          product = new
          product.name = row['name']
          product.sku = row['sku']
          product.description = row['description']
          product.short_description = row['short_description']
          product.weight = row['weight']
          product.price = row['price'].nil? ? 0 : row['price']
          product.permalink = row['permalink']

          product.product_categories << begin
            Shoppe::ProductCategory.find_or_initialize_by(name: row['category_name'])
          end
          
          product.save!

          qty = row['qty'].to_i
          if qty > 0
            product.stock_level_adjustments.create!(description: I18n.t('shoppe.import'), adjustment: qty)
          end
        end
      end
    end

    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
      when '.csv' then Roo::CSV.new(file.path)
      when '.xls' then Roo::Excel.new(file.path)
      when '.xlsx' then Roo::Excelx.new(file.path)
      else fail I18n.t('shoppe.imports.errors.unknown_format', filename: File.original_filename)
      end
    end
# ===========================GET===============================
    def get_short_description
      return  self.parent.short_description if self.variant?
      return self.short_description
    end

    def get_name
      return  self.parent.name if self.variant?
      return self.name
    end

    def get_price
      return  self.parent.price if self.variant?
      return self.price
    end

    def get_cost_price
      return  self.parent.cost_price if self.variant?
      return self.cost_price
    end

    def get_variants
      return  self.parent.variants if self.variant?
      return self.variants
    end

    def get_category
      return  self.parent.product_category if self.variant?
      return self.product_category
    end

    def get_categories
      return  self.parent.product_categories if self.variant?
      return self.product_categories
    end

    def get_sizes
      return  self.default_variant.sizes if self.has_variants? and self.default_variant.present?
      # return  self.default_variant.sizes if self.has_variants?
      return self.sizes
    end

    def get_available_sizes
      if self.has_variants? and self.default_variant.present?
        current_product = self.default_variant
        sizes = self.default_variant.sizes
      else
        current_product = self
        sizes = self.sizes
      end

      #Get stock info, size wise only If current product has enabled stock control
      if current_product.stock_control?
        return stockable_sizes(current_product, sizes)
      else
        return sizes
      end
      
    end

    def get_colors
      return  self.parent.variants.collect(&:color) if self.variant?
      return self.variants.collect(&:color)
    end

    def get_product_attributes
      return  self.parent.product_attributes if self.variant?
      return self.product_attributes
    end
# ========================GET============================

    def stockable_sizes(current_product, sizes)
      available_sizes = []
      sizes.each do |size|
        if current_product.stock(size.id) > 0
          available_sizes << size
        end
      end
      return available_sizes
    end

    def self.new_arrivals
      where(new_arrivals: true).active.limit(15)
    end

    def self.hot_selling
      where(hot_selling: true).active.limit(15)
    end

    def has_sizes?
      !get_sizes.empty?
    end

    def has_colors?
      !get_colors.empty?
    end

    def self.find_by_brands(brand)
      where(brand: brand).active
    end

    def self.find_by_color_name(color_name, category_permalink)
      # where(color_name: color_name).active  #Use this instead, when only variants have color_name
      products = where(name: color_name).active

      category = self.find_category(category_permalink)
      if category.present?
        cat_ids = category.descendants.collect(&:id) # Get All descendants of current category
        cat_ids << category.id # current category
      end

      # category_id = self.find_category(category_permalink).id
      products = self.products_for_category(products, cat_ids) if products and cat_ids
    end

    def self.find_by_category_and_descendants(category)
        cat_ids = category.descendants.collect(&:id) # Get All descendants of current category
        cat_ids << category.id
        includes(:product_categories).where('shoppe_product_categories.id' => cat_ids)
    end

    def self.products_for_category(products, cat_ids)
      # Because only Main product has category and variants get categroy from parent.
      pro_ids = []
      products.each do |product|
        if cat_ids.include?(product.get_category.id)
        # if product.get_category.id == category_id
        pro_ids << product.id
        end
      end
      products = products.where(id: pro_ids) # ids of Main Products and [Variants]
    end

    def self.find_by_size_id(size_id, category_permalink)
      size = Shoppe::Size.find(size_id)
      products = size.products.active

      category = self.find_category(category_permalink)
      if category.present?
        cat_ids = category.descendants.collect(&:id) # Get All descendants of current category
        cat_ids << category.id # current category
      end
      # Now filter products for only current category
      products = self.products_for_category(products, cat_ids) if products and cat_ids
      # Now filter products that have stocks
      if products.present?
        self.filter_stockable_products(products, size_id)
      end
    end

    def self.filter_stockable_products(products, size_id)
      ids = [] # will store ids of variants only because main products dont have stock
      products.each do |product|
        if product.stock(size_id) > 0
        ids << product.id
        end
      end
      products = products.where(id: ids)
    end

    def self.find_by_price(min_price, max_price, category_permalink)
      products = where("price >= ? AND price <= ?", min_price, max_price).active

      category = self.find_category(category_permalink)
      if category.present?
        cat_ids = category.descendants.collect(&:id) # Get All descendants of current category
        cat_ids << category.id # current category
      end
      products = self.products_for_category(products, cat_ids) if products and cat_ids
    end

    def self.find_category(category_permalink)
      Shoppe::ProductCategory.ordered.find_by_permalink(category_permalink)
    end

    def self.collect_brands
      self.active.collect(&:brand).reject(&:blank?).uniq
    end

    def self.collect_color_names
      self.active.collect(&:color_name).reject(&:blank?).uniq
    end

    def self.collect_sizes
      return Shoppe::Size.all
    end

    def styles
      category = self.get_category
      products = category.products.active.where.not(id:self.id) if category
      if products
        products = products.order("created_at DESC").limit(3)
      else
        products = Shoppe::Product.active.last(3)
      end
    end

    def self.with_translated_name(name_string)
      with_translations(I18n.locale).where('shoppe_product_translations.name' => name_string)
    end

    private

    def self.ransackable_scopes(auth_object = nil)
      %i(with_translated_name) 
    end

    # Validates

    def has_at_least_one_product_category
      errors.add(:base, 'must add at least one product category') if product_categories.blank?
    end
  end
end
