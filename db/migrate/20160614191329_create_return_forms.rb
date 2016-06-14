class CreateReturnForms < ActiveRecord::Migration
  def change
    create_table :return_forms do |t|
      t.string :order_number
      t.string :serial_number
      t.string :item_number
      t.text :description
      t.text :return_quantity
      t.string :reason
      t.string :action_detail

      t.timestamps null: false
    end
  end
end
