class ModifySections < ActiveRecord::Migration[6.1]
  def change
    add_index :sections, :name
  end
end
