class EnableGistExtension < ActiveRecord::Migration[6.1]
  def change
    enable_extension :btree_gist
  end
end
