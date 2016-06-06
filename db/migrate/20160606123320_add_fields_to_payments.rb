class AddFieldsToPayments < ActiveRecord::Migration
  def change
    add_column :shoppe_payments, :response_code, :string
    add_column :shoppe_payments, :response_description, :string
    add_column :shoppe_payments, :uniqueId, :string
    add_column :shoppe_payments, :version, :string
    add_column :shoppe_payments, :account, :string

    add_column :shoppe_payments, :approval_code, :string
    add_column :shoppe_payments, :balance, :string
    add_column :shoppe_payments, :card_brand, :string
    add_column :shoppe_payments, :card_number, :string
    add_column :shoppe_payments, :card_token, :string
    add_column :shoppe_payments, :fees, :string
    add_column :shoppe_payments, :orderID, :string
  end
end
