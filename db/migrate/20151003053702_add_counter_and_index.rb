class AddCounterAndIndex < ActiveRecord::Migration
  def change
    remove_column :keywords, :subscribe_count, :integer
    add_column :keywords, :subscribes_count, :integer
  end
end
