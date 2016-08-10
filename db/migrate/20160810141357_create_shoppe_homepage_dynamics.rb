class CreateShoppeHomepageDynamics < ActiveRecord::Migration
  def change
    create_table :shoppe_homepage_dynamics do |t|

      t.timestamps null: false
    end
  end
end
