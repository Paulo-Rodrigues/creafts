class AddUserExternalIdToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :user_external_id, :string, null: false
  end
end
