class AddKeywordNameIndex < ActiveRecord::Migration
  def change
    add_index :keywords, :name, unique: true
  end
end
