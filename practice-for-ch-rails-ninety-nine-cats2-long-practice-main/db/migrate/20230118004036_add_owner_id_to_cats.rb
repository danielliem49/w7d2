class AddOwnerIdToCats < ActiveRecord::Migration[7.0]
  def change
    add_reference :cats, :owener, null:false, foreign_key: {to_table: :users}
  end
end
