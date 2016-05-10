class AddFieldsToStokLevelAdjustments < ActiveRecord::Migration
  def change
    add_column :shoppe_stock_level_adjustments, :size_id, :integer
  end
end
