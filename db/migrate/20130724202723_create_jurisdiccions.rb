class CreateJurisdiccions < ActiveRecord::Migration
  def change
    create_table :jurisdiccions do |t|
      t.string :nombre
      t.integer :poder_id

      t.timestamps
    end
  end
end
