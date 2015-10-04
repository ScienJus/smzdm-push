class AddActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :active, :boolean, defalut: true
  end
end
