class CreateDjVista < ActiveRecord::Migration
  def change
    create_table :dj_vista do |t|
      t.integer :ddjj_id
      t.decimal :visitas
      t.date :fecha

      t.timestamps
    end
  end
end
