class TestRemoveDecimals < ActiveRecord::Migration[6.1]
  def change
    remove_column :units, :value, :decimal, precision: 21, scale: 3
  end
end
