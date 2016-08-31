class Shoppe::Policy < ActiveRecord::Base
  
  validates :title, presence: true, uniqueness: true
  validates :permalink, presence: true, uniqueness: true, permalink: true

  before_validation { self.permalink = title.parameterize if permalink.blank? && title.is_a?(String) }
end
