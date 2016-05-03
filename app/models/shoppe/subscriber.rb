class Shoppe::Subscriber < ActiveRecord::Base
  EMAIL_REGEX = /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i
  PHONE_REGEX = /\A[+?\d\ \-x\(\)]{7,}\z/
  self.table_name = 'shoppe_subscribers'
  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validates :contact_no, presence: true, format: { with: PHONE_REGEX }
end
