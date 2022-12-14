class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :code, null: false
      t.integer :kind
      t.string :name
      t.decimal :price, precision: 8, scale: 3, null: false, default: 0.000
      t.integer :stock, null: false, default: 0

      t.timestamps
    end
  end
end
