class AddNameEnableToRates < ActiveRecord::Migration[7.0]
  def change
    add_column :rates, :enable, :boolean, default: false, null: false
    add_column :rates, :name, :string
  end
end
