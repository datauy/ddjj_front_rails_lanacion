class AddColumnsToPersonas < ActiveRecord::Migration
  def change
 	add_column :personas, :tag_id, :string
 	add_column :personas, :tag_img_id, :string
 	add_column :personas, :tag_descripcion, :string
 	add_column :personas, :ficha_d_l, :string
  end
end
