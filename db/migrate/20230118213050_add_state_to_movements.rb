class AddStateToMovements < ActiveRecord::Migration[7.0]
  def change
    add_column :movements, :state, :integer, default: 0, null: false
  end
end
