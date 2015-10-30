class CreateVinculos < ActiveRecord::Migration
  def change
    create_table :vinculos do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
