class AddColumnEmailToReturnForm < ActiveRecord::Migration
  def change
    add_column :return_forms, :name, :string
    add_column :return_forms, :email, :string
    add_column :return_forms, :comment, :text
  end
end
