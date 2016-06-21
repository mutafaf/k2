class Shoppe::Job < ActiveRecord::Base

  STATUS = [['ENABLED', 1], ['DISABLED', 0]]
  validates :name, :description, presence: true, uniqueness: true
  scope :enabled, -> { where(status: true) }
  scope :last_15_days, -> { where("created_at > ?", 15.days.ago) }
  has_many :careers

end
