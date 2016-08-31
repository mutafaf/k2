class CreateShoppePolicies < ActiveRecord::Migration
  def change
    create_table :shoppe_policies do |t|
      t.string :title
      t.string :permalink
      t.integer :position
      t.text :description

      t.timestamps null: false
    end
  end
end
