class CreateShoppeHomepageSettings < ActiveRecord::Migration
  def change
    create_table :shoppe_homepage_settings do |t|

      t.string :category_permalink
      t.integer :position
      t.string :setting_for

      t.timestamps null: false
    end
  end
end
