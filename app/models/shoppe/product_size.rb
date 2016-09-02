class Shoppe::ProductSize < ActiveRecord::Base
  belongs_to :product, class_name: 'Shoppe::Product'
  belongs_to :size, class_name: 'Shoppe::Size'
end
