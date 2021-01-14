class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects, temporal: true do |t|
      t.string :name
      t.references :user

      t.timestamps null: false
    end
  end
end
