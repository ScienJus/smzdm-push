class AddSubscribeCountToKeyword < ActiveRecord::Migration
  def change
    add_column :keywords, :subscribe_count, :integer
  end
end
