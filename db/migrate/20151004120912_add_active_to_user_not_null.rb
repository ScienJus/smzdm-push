class AddActiveToUserNotNull < ActiveRecord::Migration
  def change
    remove_column :users, :active, :boolean
    add_column :users, :active, :boolean, null: false, default: true
  end
end
