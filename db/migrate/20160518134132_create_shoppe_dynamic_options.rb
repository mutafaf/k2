class CreateShoppeDynamicOptions < ActiveRecord::Migration
  def change
    create_table :shoppe_dynamic_options do |t|
      t.string   "title"
      t.string   "options_for"
      t.string   "status",      default: "active"
      t.timestamps null: false
    end
  end
end
