class AddZoneIdToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :zone_id, :uuid, index: true
    add_foreign_key :products, :zones, column: :zone_id
  end
end
