class TestAddDecimals < ActiveRecord::Migration[6.1]
  def change
    add_column :units, :value, :decimal, precision: 21, scale: 3
  end
end
