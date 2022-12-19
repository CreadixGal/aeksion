class CreateMovements < ActiveRecord::Migration[7.0]
  def change
    create_table :movements, id: :uuid do |t|
      t.references :rate, null: false, foreign_key: true, type: :uuid
      t.datetime :date
      t.string :code, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
