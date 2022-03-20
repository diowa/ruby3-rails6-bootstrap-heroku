class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies, temporal: true do |t|
      t.string :name
      t.references :studio

      t.timestamps
    end

    create_table :studios do |t|
      t.string :name

      t.timestamps
    end
  end
end
