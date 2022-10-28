class CreateProductMovements < ActiveRecord::Migration[7.0]
  def change
    create_table :product_movements, id: :uuid do |t|
      t.references :movement, null: false, foreign_key: true, type: :uuid
      t.references :product, null: false, foreign_key: true, type: :uuid
      t.integer :quantity

      t.timestamps
    end
  end
end
