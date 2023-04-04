class RemovePriceFromRates < ActiveRecord::Migration[7.0]
  def change
    remove_column :rates, :price, :float
  end
end
