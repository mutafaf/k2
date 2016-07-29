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
      products = Shoppe::Product.all
      sizes = Shoppe::Size.all

      book = Spreadsheet::Workbook.new :title => "Stock List"
      sheet1 = book.create_worksheet :name => "Stock List"
      sheet1.column(0).width = 15

      title_format = Spreadsheet::Format.new :color => :green, :weight => :bold, :size => 14, :align => :centre
      header_format = Spreadsheet::Format.new :color => :green, :weight => :bold
      product_format = Spreadsheet::Format.new :color => :green, :align => :centre
      i = 0
      sheet1.row(i).default_format = title_format
      sheet1.merge_cells(i, 0, i, sizes.count)
      sheet1.row(i).push 'Products Stock Level'
      sheet1.row(i).height = 20
      i = i+2
      sheet1.row(i).default_format = header_format

      sheet1.row(i).push 'Variants', * sizes.collect(&:name) if sizes.present?

      products.each do |product|
      i = i+1
      sheet1.row(i).height = 20
      sheet1.row(i).default_format = product_format
      sheet1.row(i).push "Product Name: #{product.name}"
      sheet1.merge_cells(i, 0, i, sizes.count)
      variants = product.get_variants
        variants.each do |variant|
        i = i+1
        sheet1.row(i).height = 20
        line = []
        line << variant.name.to_s
          sizes.each do |size|
          line << variant.stock(size.id).to_s
          end
        sheet1.row(i).push *line
        end
      end

      return book
    end

  end
end
