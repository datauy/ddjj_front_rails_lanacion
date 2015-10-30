class CreateTiempoControls < ActiveRecord::Migration
  def change
    create_table :tiempo_controls do |t|
      t.string :dias

      t.timestamps
    end
  end
end
