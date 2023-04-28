class CreateDeliveryRiders < ActiveRecord::Migration[7.0]
  def change
    create_table :delivery_riders, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
