class CreatePrices < ActiveRecord::Migration[8.0]
  def change
    create_table :prices do |t|
      t.decimal :amount, null: false, precision: 10, scale: 2
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
