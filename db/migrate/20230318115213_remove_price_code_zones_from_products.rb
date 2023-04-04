class RemovePriceCodeZonesFromProducts < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :price, :float
    remove_column :products, :code, :string
    remove_column :products, :zone_id
  end
end
