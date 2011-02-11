class Sharing < ActiveRecord::Base
  # currently, priority is in {0, 1} for invitate and recommend respectively
  # priority is defined in user_sharing and group_sharing
  MAX_PRIORITY = 2
  
  belongs_to :event
  belongs_to :user  #add by wander
  has_many :user_sharing, :dependent => :destroy
  has_many :group_sharing, :dependent => :destroy
end
