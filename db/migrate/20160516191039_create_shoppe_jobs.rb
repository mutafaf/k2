class CreateShoppeJobs < ActiveRecord::Migration
  def change
    create_table :shoppe_jobs do |t|
      t.string :name
      t.text :description
      t.boolean :status
      t.integer :position
      t.timestamps null: false
    end
  end
end