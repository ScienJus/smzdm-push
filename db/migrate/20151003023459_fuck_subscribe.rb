class FuckSubscribe < ActiveRecord::Migration
  def change
    drop_table :subscribes
    
    create_table :subscribes do |t|
      t.belongs_to :user
      t.belongs_to :keyword

      t.timestamps null: false
    end
  end
end
