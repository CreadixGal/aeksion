class RemoveProductFromProductMovement < ActiveRecord::Migration[7.0]
  def change
    remove_reference :product_movements, :product, null: false, foreign_key: true
    add_reference :product_movements, :variant, null: false, foreign_key: true, type: :uuid
  end
end
