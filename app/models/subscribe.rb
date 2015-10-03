class Subscribe < ActiveRecord::Base
  belongs_to :user
  belongs_to :keyword, counter_cache: true
  
  validates_uniqueness_of :user_id, :scope => :keyword_id
end