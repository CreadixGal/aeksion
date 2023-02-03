class CreatePrices < ActiveRecord::Migration[7.0]
  def change
    create_table :prices, id: :uuid do |t|
      t.references :cost, polymorphic: true, null: false, index: true, type: :uuid
      t.decimal :quantity, :decimal, default: 0.0000, precision: 8, scale: 4

      t.timestamps
    end
  end
end
