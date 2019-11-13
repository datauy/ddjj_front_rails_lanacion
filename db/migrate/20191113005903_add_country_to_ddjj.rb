class AddCountryToDdjj < ActiveRecord::Migration
  def change
    add_column :ddjjs, :country, :string
    add_index :ddjjs, :country
  end
end
