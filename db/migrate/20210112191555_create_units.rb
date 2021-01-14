class CreateUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :units, temporal: true do |t|
      t.string :name
      t.references :project

      t.timestamps null: false
    end
  end
end
