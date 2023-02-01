class DefaultValueStatusMovement < ActiveRecord::Migration[7.0]
  def change
    change_column :movements, :status, :integer, :default => 0
  end
end
