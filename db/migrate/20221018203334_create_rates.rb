class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rates, id: :uuid do |t|
      t.references :customer, null: false, foreign_key: true, type: :uuid
      t.references :zone, null: false, foreign_key: true, type: :uuid
      t.integer :kind
      t.float :price, precision: 8, scale: 3

      t.timestamps
    end
  end
end
