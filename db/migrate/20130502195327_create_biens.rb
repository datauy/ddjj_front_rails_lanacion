class CreateBiens < ActiveRecord::Migration
  def change
    create_table :biens do |t|
      t.integer :tipo_bien_id
      t.integer :nombre_bien_id
      t.string :tipo_bien_s
      t.string :nombre_bien_s
      t.string :descripcion
      t.string :direccion
      t.string :barrio
      t.string :localidad
      t.string :provincia
      t.string :pais
      t.integer :modelo
      t.string :entidad
      t.string :ramo
      t.string :cant_acciones
      t.date :fecha_desde
      t.string :destino
      t.string :origen
      t.decimal :superficie, precision: 10, scale: 2
      t.integer :unidad_medida_id
      t.integer :m_mejoras_id
      t.decimal :mejoras, precision: 15, scale: 2
      t.integer :m_valor_fiscal_id
      t.decimal :valor_fiscal, precision: 15, scale: 2
      t.integer :m_valor_adq_id
      t.decimal :valor_adq, precision: 15, scale: 2
      t.date :fecha_hasta
      t.string :titular_dominio
      t.decimal :porcentaje, precision: 10, scale: 2
      t.string :vinculo
      t.string :periodo
      t.string :obs
      t.integer :persona_id
      t.integer :ddjj_id
      t.timestamps
    end
  end
end
