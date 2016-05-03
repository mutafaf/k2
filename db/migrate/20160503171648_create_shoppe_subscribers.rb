class CreateShoppeSubscribers < ActiveRecord::Migration
  def change
    create_table :shoppe_subscribers do |t|
      t.string :email
      t.string :contact_no

      t.timestamps null: false
    end
  end
end
