class CreateContenidoDdjjs < ActiveRecord::Migration
  def change
    create_table :contenido_ddjjs do |t|
      t.integer :ddjj_id
      t.string :ddjj_ano
      t.string :ddjj_tipo
      t.integer :poder_id
      t.string :persona_str
      t.integer :persona_id
      t.string :cargo_str
      t.integer :cargo_id
      t.text :contenido

      t.timestamps
    end
    add_index :contenido_ddjjs, [:ddjj_id, :contenido], :length => { :contenido => 5 }
  end
end
