module Shoppe
  class StockLevelAdjustment < ActiveRecord::Base
    # The orderable item which the stock level adjustment belongs to
    belongs_to :item, polymorphic: true
    belongs_to :size

    # The parent (OrderItem) which the stock level adjustment belongs to
    belongs_to :parent, polymorphic: true

    # Validations
    validates :description, presence: true
    validates :adjustment, numericality: true
    validate { errors.add(:adjustment, I18n.t('shoppe.activerecord.attributes.stock_level_adjustment.must_be_greater_or_equal_zero')) if adjustment == 0 }

    # All stock level adjustments ordered by their created date desending
    scope :ordered, -> { order(id: :desc) }




    def self.to_xls(options = {})
      grouped_products = Shoppe::Product.root
                                       .includes(:translations, :stock_level_adjustments, :product_categories, :variants)
                                       .order(:name)
                                       .group_by(&:product_category)
                                       .sort_by { |cat, _pro| cat.name }
      sizes = Shoppe::Size.all
      if sizes.present?
        sizes_names = sizes.collect(&:name)
      else
        sizes_names = []
      end

      book = Spreadsheet::Workbook.new :title => "Stock List"
      sheet1 = book.create_worksheet :name => "Stock List"
      sheet1.column(0).width = 20
      
      title_format = Spreadsheet::Format.new :color => :green, :weight => :bold, :size => 14, :align => :centre
      header_format = Spreadsheet::Format.new :color => :green, :weight => :bold
      category_format = Spreadsheet::Format.new :color => :green, :align => :centre, :weight => :bold
      i = 0
      sheet1.row(i).default_format = title_format
      sheet1.merge_cells(i, 0, i, sizes.count)
      sheet1.row(i).push 'Products Stock Level'
      sheet1.row(i).height = 20
      i = i+2
      sheet1.row(i).default_format = header_format

      sheet1.row(i).push 'Product Name','Variant', *sizes_names,'Grand Total'
      grouped_products.each do |category, products|
        i = i+1
        sheet1.row(i).height = 15
        sheet1.row(i).default_format = category_format
        sheet1.row(i).push category.get_category_sequence
        sheet1.merge_cells(i, 0, i, sizes.count)
        products.each do |product|
        variants = product.get_variants
          variants.each do |variant|
          i = i+1
          sheet1.row(i).height = 15
          line = []
          line << product.name.to_s
          line << variant.name.to_s
            sizes.each do |size|
            line << variant.stock(size.id).to_s
            end
            line << variant.stock
          sheet1.row(i).push *line
          end
        end
      end

      return book
    end

    def self.import(file)
      
    end

  end
end
