class CreateZones < ActiveRecord::Migration[7.0]
  def change
    create_table :zones, id: :uuid do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
