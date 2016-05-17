class Shoppe::Job < ActiveRecord::Base

  STATUS = [['ENABLED', 1], ['DISABLED', 0]]
  validates :name, :description, presence: true, uniqueness: true
  scope :enabled, -> { where(status: true) }
  has_many :careers

end
