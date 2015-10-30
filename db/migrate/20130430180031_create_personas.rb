class CreatePersonas < ActiveRecord::Migration
  def change
    create_table :personas do |t|
      t.string :apellido
      t.string :nombre
      t.string :legajo
      t.integer :tipo_documento_id
      t.integer :documento
      t.string :cuit_cuil
      t.date :nacimento
      t.integer :sexo_id
      t.integer :estado_civil_id

      t.timestamps
    end
  end
end
