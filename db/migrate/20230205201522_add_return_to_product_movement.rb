class AddReturnToProductMovement < ActiveRecord::Migration[7.0]
  def change
    add_column :product_movements, :return, :boolean, null: false, default: false
  end
end
