class CreateCargos < ActiveRecord::Migration
  def change
    create_table :cargos do |t|
      t.string :jurisdiccion
      t.string :cargo
      t.integer :poder_id

      t.timestamps
    end
  end
end
