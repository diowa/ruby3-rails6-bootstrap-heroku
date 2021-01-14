class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, temporal: true do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
