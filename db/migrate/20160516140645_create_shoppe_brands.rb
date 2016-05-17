class CreateShoppeBrands < ActiveRecord::Migration
  def change
    create_table :shoppe_brands do |t|
      t.string :name
      t.text :description
      t.string :permalink
      t.integer :position
      t.timestamps null: false
    end
  end
end
