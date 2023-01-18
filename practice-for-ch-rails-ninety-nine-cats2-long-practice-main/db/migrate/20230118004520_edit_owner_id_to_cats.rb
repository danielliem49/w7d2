class EditOwnerIdToCats < ActiveRecord::Migration[7.0]
  def change
    rename_column :cats, :owener_id, :owner_id
  end
end
