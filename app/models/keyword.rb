class Keyword < ActiveRecord::Base
  
  has_many :subscribes, dependent: :destroy
  has_many :users, through: :subscribes
end