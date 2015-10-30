class CreateDdjjs < ActiveRecord::Migration
  def change
    create_table :ddjjs do |t|
      t.integer :ano
      t.integer :tipo_ddjj_id
      t.string  :funcionario
      t.string  :url
      t.integer :persona_cargo_id
      t.integer :persona_id
      t.integer :key
      t.integer :poder_id
      t.string  :clave
      t.boolean :flag_presenta
      t.text    :obs
      t.string  :flag_search
      t.decimal :visitas
      t.boolean :status

      t.timestamps
    end
  end
end
