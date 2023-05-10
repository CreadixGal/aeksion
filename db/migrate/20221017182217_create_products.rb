class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: :uuid do |t|
      t.integer :kind
      t.string :name
      t.integer :stock, null: false, default: 0

      t.timestamps
    end
  end
end
