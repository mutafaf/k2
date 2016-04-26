class Shoppe::Size < ActiveRecord::Base
  has_many :product_sizes, class_name: 'Shoppe::ProductSize'
  has_many :products, through: :product_sizes, class_name: 'Shoppe::Product'
end
