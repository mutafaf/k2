class AddFieldsToAddress < ActiveRecord::Migration
  def change
    add_column :shoppe_addresses, :city, :string
    change_column :shoppe_addresses, :address1,  :text
  end
end
