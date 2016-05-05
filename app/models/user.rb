class User < ActiveRecord::Base

  has_one :customer, class_name: 'Shoppe::Customer'
  accepts_nested_attributes_for :customer
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
