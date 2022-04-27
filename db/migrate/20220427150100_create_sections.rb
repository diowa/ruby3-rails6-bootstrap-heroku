class CreateSections < ActiveRecord::Migration[6.1]
  def change
    create_table 'sections', temporal: true, no_journal: %w( articles_count ) do |t|
      t.string :name
      t.integer :articles_count, default: 0
    end
  end
end
