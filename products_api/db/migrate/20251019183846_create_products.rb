class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.references :category, null: false, foreign_key: true
      t.integer :status, null: false, default: 1

      t.timestamps
    end
  end
end
