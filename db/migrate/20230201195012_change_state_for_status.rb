class ChangeStateForStatus < ActiveRecord::Migration[7.0]
  def self.up
    rename_column :movements, :state, :status
  end
end
