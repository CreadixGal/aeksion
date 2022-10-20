class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :code, null: false
      t.integer :kind
      t.string :name
      t.float :price, precision: 8, scale: 3
      t.integer :stock

      t.timestamps
    end
  end
end
