class AddDeliveryRiderToRates < ActiveRecord::Migration[7.0]
  def change
    add_reference :rates, :delivery_rider, null: true, foreign_key: true, type: :uuid
    change_column_null :rates, :customer_id, true
  end
end
