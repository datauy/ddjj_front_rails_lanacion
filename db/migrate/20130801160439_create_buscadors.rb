class CreateBuscadors < ActiveRecord::Migration
  def change
    create_table :buscadors do |t|
      t.integer :poder
      t.text :nombre_bienes
      t.text :personas
      t.text :cargos
      t.timestamps
    end
  end
end
