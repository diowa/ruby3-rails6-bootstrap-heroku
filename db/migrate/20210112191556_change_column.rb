class ChangeColumn < ActiveRecord::Migration[6.1]
  def change
    change_column :units, :name, :string, null: false
  end
end
