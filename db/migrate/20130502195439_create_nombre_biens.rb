class CreateNombreBiens < ActiveRecord::Migration
  def change
    create_table :nombre_biens do |t|
      t.string :nombre
      t.integer :tipo_bien_id

      t.timestamps
    end
  end
end
