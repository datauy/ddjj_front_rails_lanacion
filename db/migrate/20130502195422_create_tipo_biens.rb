class CreateTipoBiens < ActiveRecord::Migration
  def change
    create_table :tipo_biens do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
