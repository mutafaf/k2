class SetDefaultValueInPayment < ActiveRecord::Migration
  def change
    change_column :shoppe_payments, :confirmed, :boolean, :default => false
  end
end
