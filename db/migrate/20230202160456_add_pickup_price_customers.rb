class AddPickupPriceCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :pickup_price, :decimal, null: false, default: 0.0000, precision: 8, scale: 4
  end
end
