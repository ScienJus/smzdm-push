class ChangeSubscribe < ActiveRecord::Migration
  def change
    drop_table :subscribes
    
    create_table :subscribes do |t|
      t.belongs_to :user_id
      t.belongs_to :keyword_id

      t.timestamps null: false
    end
  end
end
