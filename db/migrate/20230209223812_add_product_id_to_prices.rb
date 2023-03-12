class AddProductIdToPrices < ActiveRecord::Migration[7.0]
  def change
    add_reference :prices, :product, null: true, foreign_key: true, type: :uuid
  end
end
