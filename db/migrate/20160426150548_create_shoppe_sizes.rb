class CreateShoppeSizes < ActiveRecord::Migration
  def change
    create_table :shoppe_sizes do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
