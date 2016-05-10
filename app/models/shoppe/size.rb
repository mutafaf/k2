class Shoppe::Size < ActiveRecord::Base
  self.table_name = 'shoppe_sizes'

  has_many :product_sizes, class_name: 'Shoppe::ProductSize'
  has_many :products, through: :product_sizes, class_name: 'Shoppe::Product'
  has_many :stock_level_adjustments, dependent: :destroy, class_name: 'Shoppe::StockLevelAdjustment', as: :item

  validates :name, presence: true, uniqueness: true
end
