class CreateVariants < ActiveRecord::Migration[7.0]
  def change
    create_table :variants, id: :uuid do |t|
      t.references :product, null: false, foreign_key: true, type: :uuid
      t.references :price, null: false, foreign_key: true, type: :uuid
      t.references :zone, null: false, foreign_key: true, type: :uuid
      t.string :code

      t.timestamps
    end
  end
end
