class UpdateFieldInBlogs < ActiveRecord::Migration
  def change
    rename_column :shoppe_blogs, :name, :title
  end
end
